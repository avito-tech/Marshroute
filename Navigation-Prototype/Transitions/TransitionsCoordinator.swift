import Foundation

/// Протокол описывает передачу обработки перехода в центр управления переходами
protocol TransitionsCoordinator: class {
    func coordinatePerformingTransition(
        context context: ForwardTransitionContext,
        forTransitionsHandler transitionsHandler: TransitionsHandler)
    
    func coordinateUndoingTransitionsAfter(
        transitionId transitionId: TransitionId,
        forTransitionsHandler transitionsHandler: TransitionsHandler)
    
    func coordinateUndoingTransitionWith(
        transitionId transitionId: TransitionId,
        forTransitionsHandler transitionsHandler: TransitionsHandler)
    
    func coordinateUndoingAllChainedTransitions(
        forTransitionsHandler transitionsHandler: TransitionsHandler)
    
    func coordinateUndoingAllTransitions(
        forTransitionsHandler transitionsHandler: TransitionsHandler)
    
    func coordinateResettingWithTransition(
        context context: ForwardTransitionContext,
        forTransitionsHandler transitionsHandler: TransitionsHandler)
}

// MARK: - TransitionsCoordinator Default Impl
extension TransitionsCoordinator where Self: TransitionContextsStackClientProviderStorer {
    typealias AnimatingTransitionsHandler = protocol<TransitionsHandler, TransitionsAnimatorClient>
    
    func coordinatePerformingTransition(
        context context: ForwardTransitionContext,
        forTransitionsHandler transitionsHandler: TransitionsHandler)
    {
        coordinatePerformingTransitionImpl(
            context: context,
            forTransitionsHandler: transitionsHandler
        )
    }
    
    func coordinateUndoingTransitionsAfter(
        transitionId transitionId: TransitionId,
        forTransitionsHandler transitionsHandler: TransitionsHandler)
    {
        coordinateUndoingTransitionsImpl(
            afterTransitionId: transitionId,
            includingTransitionWithId: false,
            forTransitionsHandler: transitionsHandler
        )
    }
    
    func coordinateUndoingTransitionWith(
        transitionId transitionId: TransitionId,
        forTransitionsHandler transitionsHandler: TransitionsHandler)
    {
        coordinateUndoingTransitionsImpl(
            afterTransitionId: transitionId,
            includingTransitionWithId: true,
            forTransitionsHandler: transitionsHandler
        )
    }
    
    func coordinateUndoingAllChainedTransitions(
        forTransitionsHandler transitionsHandler: TransitionsHandler)
    {
        coordinateUndoingAllChainedTransitionsImpl(
            forTransitionsHandler: transitionsHandler
        )
    }
    
    func coordinateUndoingAllTransitions(
        forTransitionsHandler transitionsHandler: TransitionsHandler)
    {
        coordinateUndoingAllTransitionsImpl(
            forTransitionsHandler: transitionsHandler
        )
    }
    
    func coordinateResettingWithTransition(
        context context: ForwardTransitionContext,
        forTransitionsHandler transitionsHandler: TransitionsHandler)
    {
        coordinateResettingWithTransitionImpl(
            context: context,
            forTransitionsHandler: transitionsHandler
        )
    }
}

// MARK: - implementations
private extension TransitionsCoordinator where Self: TransitionContextsStackClientProviderStorer {
    func coordinatePerformingTransitionImpl(
        context context: ForwardTransitionContext,
        forTransitionsHandler transitionsHandler: TransitionsHandler)
    {
        // ищем вложенные анимирующие обработчики переходов (например, для split'а, найдем его master и detail)
        let notContainerTransitionsHandlers = findNotContainerTransitionsHandlers(
            forTransitionsHandler: transitionsHandler,
            amongVisibleChildTransitionHandlers: true) // ищем среди видимых (то есть в выбранном tab'e tabbar'a)
        
        // проверяем, что вызван правильный метод (перед первым perform должен идти reset)
        assertAnimatorClientsOnPerformTransitionOperation(animatorClients: notContainerTransitionsHandlers)
        
        // выбираем из найденных анимирующих обработчиков один с самым глубоким дочерним обработчиком
        // и получаем этого обработчика, чтобы прокинуть ему обработку перехода
        guard let selectedTransitionsHandler = selectTransitionsHandlerToPerformOrReset(
            amongTransitionsHandlers: notContainerTransitionsHandlers)
            else { return }
        
        guard let animatingTransitionsHandler = selectedTransitionsHandler as? AnimatingTransitionsHandler
            else { assert(false, "к этому моменту должен быть выбран анимирующий обработчик переходов"); return }
        
        guard let stackClient = stackClientProvider.stackClient(forTransitionsHandler: animatingTransitionsHandler)
            else { return }
        
        // вызываем анимации
        animatingTransitionsHandler.launchAnimatingOfPerformingTransition(launchingContext: context.animationLaunchingContext)
        
        // создаем новую запись о переходе
        commitPerformingTransition(
            context: context,
            forTransitionsHandler: transitionsHandler,
            animatingTransitionsHandler: animatingTransitionsHandler,
            withStackClient: stackClient
        )
    }
    
    func coordinateUndoingTransitionsImpl(
        afterTransitionId transitionId: TransitionId,
        includingTransitionWithId: Bool,
        forTransitionsHandler transitionsHandler: TransitionsHandler)
    {
        // ищем вложенные анимирующие обработчики переходов (например, для split'а, найдем его master и detail)
        let notContainerTransitionsHandlers = findNotContainerTransitionsHandlers(
            forTransitionsHandler: transitionsHandler,
            amongVisibleChildTransitionHandlers: false) // ищем среди всех (то есть всех tab'ов tabbar'a)
        
        // выбираем из найденных анимирующих обработчиков тот, что ранее выполнял отменяемый переход
        guard let selectedTransitionsHandler = selectTransitionsHandler(
            amongTransitionsHandlers: notContainerTransitionsHandlers,
            toUndoTransitionsAfterId: transitionId,
            includingTransitionWithId: includingTransitionWithId)
            else { assert(false, "к этому моменту должен быть найден обработчик, выполнивший переход с этим id"); return }
        
        guard let animatingTransitionsHandler = selectedTransitionsHandler as? AnimatingTransitionsHandler
            else { assert(false, "к этому моменту должен быть выбран анимирующий обработчик переходов"); return }
        
        guard let stackClient = stackClientProvider.stackClient(forTransitionsHandler: animatingTransitionsHandler)
            else { return }
        
        // готовим список переходов, которые нужно отменить
        let transitionsToUndo = stackClient.transitionsAfter(
            transitionId: transitionId,
            forTransitionsHandler: animatingTransitionsHandler,
            includingTransitionWithId: includingTransitionWithId
        )
        
        // переход с открытием модального окна или поповера
        let chainedTransition = transitionsToUndo.chainedTransition
        
        // переходы по навигационному стеку
        let pushTransitions = transitionsToUndo.pushTransitions
        
        coordinateUndoingTransitionsImpl(
            chainedTransition: chainedTransition,
            pushTransitions: pushTransitions,
            forAnimatingTransitionsHandler: animatingTransitionsHandler,
            andCommitUndoingTransitionsAfter: transitionId,
            includingTransitionWithId: includingTransitionWithId,
            withStackClient: stackClient
        )
    }
    
    func coordinateUndoingAllChainedTransitionsImpl(
        forTransitionsHandler transitionsHandler: TransitionsHandler)
    {
        // ищем вложенные анимирующие обработчики переходов (например, для split'а, найдем его master и detail)
        let notContainerTransitionsHandlers = findNotContainerTransitionsHandlers(
            forTransitionsHandler: transitionsHandler,
            amongVisibleChildTransitionHandlers: true) // ищем среди видимых (то есть в выбранном tab'e tabbar'a)
        
        assert(
            notContainerTransitionsHandlers?.count <= 1,
            "методы undo без transitionId посылаем только анимирующим обработчикам переходов"
        )
        
        guard let animatingTransitionsHandler = notContainerTransitionsHandlers?.first as? AnimatingTransitionsHandler
            else { assert(false, "к этому моменту должен быть выбран анимирующий обработчик переходов"); return }
        
        // скрываем модальные окна и поповеры, показанных внутри модальных окон и поповеров текущего обработчика
        coordinateUndoingChainedTransitionsIfNeededImpl(forTransitionsHandler: animatingTransitionsHandler)
        
        assert(
            animatingTransitionsHandler === transitionsHandler,
            "методы undo без transitionId посылаем только анимирующим обработчикам переходов"
        )
        
        guard let stackClient = stackClientProvider.stackClient(forTransitionsHandler: animatingTransitionsHandler)
            else { return }
        
        // отменить нужно только переход с открытием модального окна или поповера
        guard let chainedTransition = stackClient.chainedTransitionForTransitionsHandler(animatingTransitionsHandler)
            else { return }
        
        coordinateUndoingTransitionsImpl(
            chainedTransition: chainedTransition,
            pushTransitions: nil,
            forAnimatingTransitionsHandler: animatingTransitionsHandler,
            andCommitUndoingTransitionsAfter: chainedTransition.transitionId,
            includingTransitionWithId: true,
            withStackClient: stackClient
        )
    }
    
    func coordinateUndoingChainedTransitionsIfNeededImpl(forTransitionsHandler transitionsHandler: TransitionsHandler)
    {
        // по-хорошему нужно убрать все модальные окна и поповеры дочерних обработчиков переходов.
        // но обнаружились следующие особенности UIKit'а
        //
        // 1. iOS 8, 9:     если скрывать последовательность из поповеров,
        //                      то UIKit падает при анимировании больших (> 3) последовательностей
        //                  если не скрывать последовательности из поповеров, а скрывать только нижний,
        //                      то UIKit отрабатывает правильно
        // 2. iOS 7:        если скрывать последовательность из поповеров,
        //                      то UIKit отрабатывает правильно
        //                  если не скрывать последовательности из поповеров, а скрывать только нижний,
        //                      то UIKit падает, потому что ```popover dealloc reached while popover is visible```
        // 3. iOS 7, 8, 9:  если скрывать последовательность из модальных окон,
        //                      то UIKit не падает, но просто не выполняет сокрытие примерно на середине последовательности
        //
        // в итоге договорились  не убирать дочерние модальные окна и поповеры,
        // а на iOS 7 не использовать поповеры вообще или использовать аккуратно:
        //
        // а) на iOS 7 не показывать поповер в поповере
        // б) на iOS 7 не показывать поповеры внутри модальных окон
        // в) игнорировать пункты а) и б), но не вызывать сокрытие целой цепочки модальных окон и поповеров
        
        // guard let stackClient = stackClientProvider.stackClient(forTransitionsHandler: transitionsHandler)
        //     else { return }
        // let chainedTransitionsHandler = stackClient.chainedTransitionsHandlerForTransitionsHandler(self)
        // chainedTransitionsHandler?.undoAllChainedTransitions()
    }
    
    func coordinateUndoingAllTransitionsImpl(
        forTransitionsHandler transitionsHandler: TransitionsHandler)
    {
        // ищем вложенные анимирующие обработчики переходов (например, для split'а, найдем его master и detail)
        let notContainerTransitionsHandlers = findNotContainerTransitionsHandlers(
            forTransitionsHandler: transitionsHandler,
            amongVisibleChildTransitionHandlers: true)  // ищем среди видимых (то есть в выбранном
        
        assert(
            notContainerTransitionsHandlers?.count <= 1,
            "методы undo без transitionId посылаем только анимирующим обработчикам переходов"
        )
        
        guard let animatingTransitionsHandler = notContainerTransitionsHandlers?.first as? AnimatingTransitionsHandler
            else { assert(false, "к этому моменту должен быть выбран анимирующий обработчик переходов"); return }
        
        // скрываем модальные окна и поповеры, показанных внутри модальных окон и поповеров текущего обработчика
        coordinateUndoingChainedTransitionsIfNeededImpl(forTransitionsHandler: animatingTransitionsHandler)
        
        assert(
            animatingTransitionsHandler === transitionsHandler,
            "методы undo без transitionId посылаем только анимирующим обработчикам переходов"
        )
        
        guard let stackClient = stackClientProvider.stackClient(forTransitionsHandler: animatingTransitionsHandler)
            else { return }
        
        // готовим список переходов, которые нужно отменить
        let transitionsToUndo = stackClient.allTransitionsForTransitionsHandler(animatingTransitionsHandler)
        
        // переход с открытием модального окна или поповера
        let chainedTransition = transitionsToUndo.chainedTransition
        
        // переходы по навигационному стеку
        let pushTransitions = transitionsToUndo.pushTransitions
        
        guard let firstTransitionId = pushTransitions?.first?.transitionId
            else { return }
        
        coordinateUndoingTransitionsImpl(
            chainedTransition: chainedTransition,
            pushTransitions: pushTransitions,
            forAnimatingTransitionsHandler: animatingTransitionsHandler,
            andCommitUndoingTransitionsAfter: firstTransitionId,
            includingTransitionWithId: false,
            withStackClient: stackClient
        )
    }
    
    func coordinateResettingWithTransitionImpl(
        context context: ForwardTransitionContext,
        forTransitionsHandler transitionsHandler: TransitionsHandler)
    {
        guard let animatingTransitionsHandler = transitionsHandler as? AnimatingTransitionsHandler else {
            assert(false, "метод reset посылаем только анимирующим обработчикам переходов")
        }

        // скрываем модальные окна и поповеры, показанных внутри модальных окон и поповеров текущего обработчика
        coordinateUndoingChainedTransitionsIfNeededImpl(forTransitionsHandler: transitionsHandler)
        
        // ищем существующую историю переходов или создаем новую
        let stackClient = stackClientProvider.stackClient(forTransitionsHandler: animatingTransitionsHandler)
            ?? stackClientProvider.createStackClient(forTransitionsHandler: animatingTransitionsHandler)
        
        // ищем идентификатор самого первого перехода
        let transitionsToUndo = stackClient.allTransitionsForTransitionsHandler(transitionsHandler)
        let chainedTransition = transitionsToUndo.chainedTransition
        let pushTransitions = transitionsToUndo.pushTransitions
        
        // скрываем модальные окна и поповеры текущего обработчика переходов
        // удаляем записи о первом и последующих переходах
        if let firstTransitionId = pushTransitions?.first?.transitionId {
            coordinateUndoingTransitionsImpl(
                chainedTransition: chainedTransition,
                pushTransitions: nil, // только модальные окна и поповеры
                forAnimatingTransitionsHandler: animatingTransitionsHandler,
                andCommitUndoingTransitionsAfter: firstTransitionId,
                includingTransitionWithId: false,
                withStackClient: stackClient
            )
        }
        
        // вызываем анимации
        animatingTransitionsHandler.launchAnimatingOfResettingWithTransition(launchingContext: context.animationLaunchingContext)
        
        // создаем новую запись о переходе
        commitResettingWithTransition(
            context: context,
            forTransitionsHandler: animatingTransitionsHandler,
            withStackClient: stackClient
        )
    }
    
    //MARK: helper
    func coordinateUndoingTransitionsImpl(
        chainedTransition chainedTransition: RestoredTransitionContext?,
        pushTransitions: [RestoredTransitionContext]?,
        forAnimatingTransitionsHandler animatingTransitionsHandler: AnimatingTransitionsHandler,
        andCommitUndoingTransitionsAfter transitionId: TransitionId,
        includingTransitionWithId: Bool,
        withStackClient stackClient: TransitionContextsStackClient)
    {
        // скрываем модальные окна и поповеры, показанных внутри модальных окон и поповеров текущего обработчика
        coordinateUndoingChainedTransitionsIfNeededImpl(forTransitionsHandler: animatingTransitionsHandler)
        
        // вызываем анимации сокрытия модальных окон и поповеров
        if let animationLaunchingContext = chainedTransition?.animationLaunchingContext {
            animatingTransitionsHandler.launchAnimatingOfUndoingTransition(launchingContext: animationLaunchingContext)
        }
        
        // вызываем анимации возвращения по навигационному стеку, минуя промежуточные переходы
        if let animationLaunchingContext = pushTransitions?.first?.animationLaunchingContext {
            animatingTransitionsHandler.launchAnimatingOfUndoingTransition(launchingContext: animationLaunchingContext)
        }
        
        // удаляем записи об отмененных переходах
        commitUndoingTransitionsAfter(
            transitionId: transitionId,
            includingTransitionWithId: includingTransitionWithId,
            forTransitionsHandler: animatingTransitionsHandler,
            withStackClient: stackClient
        )
    }
}

// MARK: - fetching data from the history
private extension TransitionsCoordinator where Self: TransitionContextsStackClientProviderStorer {
    
    /// Поиск вложенных анимирующих обработчиков переходов
    /// (например, для split'а, найдутся его master и detail)
    func findNotContainerTransitionsHandlers(
        forTransitionsHandler transitionsHandler: TransitionsHandler,
        amongVisibleChildTransitionHandlers: Bool) // false, если Undo with Id, Undo after Id
        -> [TransitionsHandler]?
    {
        var result: [TransitionsHandler]? = nil
        
        // поиск проводится только для контейнеров-обработчиков
        if let transitionsHandler = transitionsHandler as? TransitionsHandlersContainer {
            let nextTransitionsHandlers = (amongVisibleChildTransitionHandlers)
                    // при perform, reset прокидываем только видимым обработчикам
                ? transitionsHandler.visibleTransitionsHandlers
                    // при undo прокидывание может понадобиться любому обработчику
                : transitionsHandler.allTransitionsHandlers
            
            if let nextTransitionsHandlers = nextTransitionsHandlers {
                result = [TransitionsHandler]()
                
                for nextTransitionsHandler in nextTransitionsHandlers {
                    if let subResult = findNotContainerTransitionsHandlers(
                        forTransitionsHandler: nextTransitionsHandler,
                        amongVisibleChildTransitionHandlers: amongVisibleChildTransitionHandlers)
                    {
                        for subResultItem in subResult {
                            result?.append(subResultItem)
                        }
                    }
                }
            }
        }
        else {
            result = [transitionsHandler]
        }
        
        return result
    }
    
    /// Выбор из обработчиков переходов одного с самым глубоким дочерним обработчиком.
    /// Возвращается найденный самый глубокий обработчик, чтобы прокинуть ему обработку перехода
    func selectTransitionsHandlerToPerformOrReset(
        amongTransitionsHandlers transitionsHandlers: [TransitionsHandler]?)
        -> TransitionsHandler?
    {
        guard let transitionsHandlers = transitionsHandlers
            else { return nil }
        
        // нужно найти максимально вложенного дочернего обработчика переходов
        var chainedTransitionsHandlers = [TransitionsHandler]()
        
        for transitionsHandler in transitionsHandlers {
            guard let stackClient = stackClientProvider.stackClient(forTransitionsHandler: transitionsHandler)
                else { continue }
            
            guard let chainedTransitionsHandler = stackClient.chainedTransitionsHandlerForTransitionsHandler(transitionsHandler)
                else { continue }
            
            chainedTransitionsHandlers.append(chainedTransitionsHandler)
        }
        
        // если нашли несколько дочерних обработчиков на одинаковой глубине вложенности, то берем любой.
        // у Split'а будет master, если ни master, ни detail не показывали модальных окон или поповеров
        if chainedTransitionsHandlers.isEmpty {
            return transitionsHandlers.first
        }
        
        return selectTransitionsHandlerToPerformOrReset(amongTransitionsHandlers: chainedTransitionsHandlers)
    }
    
    /// Поиск обработчика переходов, выполнявшего переход с переданным id. 
    /// Если такой не найден, поиск продолжается по дочерним обработчикам
    func selectTransitionsHandler(
        amongTransitionsHandlers transitionsHandlers: [TransitionsHandler]?,
        toUndoTransitionsAfterId transitionId: TransitionId,
        includingTransitionWithId: Bool)
        -> TransitionsHandler?
    {
        guard let transitionsHandlers = transitionsHandlers
            else { return nil }
        
        for transitionsHandler in transitionsHandlers {
            guard let stackClient = stackClientProvider.stackClient(forTransitionsHandler: transitionsHandler)
                else { continue }
            
            // если какой-то обработчик выполнял переход с переданным id, возвращаем его
            let transitionWithId = stackClient.transitionWith(
                transitionId: transitionId,
                forTransitionsHandler: transitionsHandler)

            if transitionWithId != nil {
                return transitionsHandler
            }
            
            // иначе смотрим дочерние обработчики
            var chainedTransitionsHandler = stackClient.chainedTransitionsHandlerForTransitionsHandler(transitionsHandler)
            
            while chainedTransitionsHandler != nil {
                guard let chainedStackClient = stackClientProvider.stackClient(forTransitionsHandler: chainedTransitionsHandler!)
                    else { break }
                
                // если какой-то дочерний обработчик выполнял переход с переданным id, возвращаем его                
                let chainedTransitionWithId = chainedStackClient.transitionWith(
                    transitionId: transitionId,
                    forTransitionsHandler: chainedTransitionsHandler!)
                
                if  chainedTransitionWithId != nil {
                    return chainedTransitionsHandler
                }
                
                chainedTransitionsHandler = chainedStackClient.chainedTransitionsHandlerForTransitionsHandler(chainedTransitionsHandler!)
            }
        }
        
        return nil
    }
}

// MARK: - committing to the history
private extension TransitionsCoordinator where Self: TransitionContextsStackClientProviderStorer {
    func commitPerformingTransition(
        context context: ForwardTransitionContext,
        forTransitionsHandler transitionsHandler: TransitionsHandler,
        animatingTransitionsHandler: AnimatingTransitionsHandler,
        withStackClient stackClient: TransitionContextsStackClient)
    {
        // в случае, когда push переход был прокинут дочернему обработчику переходов,
        // нужно обновлять targetTransitionsHandler, чтобы не было зацикливаний при последующем прокидывании
        let fixedContext: ForwardTransitionContext
        
        if transitionsHandler === context.targetTransitionsHandler && transitionsHandler !== animatingTransitionsHandler {
            fixedContext =  ForwardTransitionContext(
                context: context,
                changingTargetTransitionsHandler: animatingTransitionsHandler
            )
        }
        else {
            fixedContext = context
        }
        
        // ищем последний переход, выполненный анимирующим обработчиком
        guard let lastTransition = stackClient.lastTransitionForTransitionsHandler(animatingTransitionsHandler) else {
            assert(false, "нужно было вызывать resetWithTransition(context:). а не performTransition(context:)")
            return
        }
        
        // достаем view controller, откуда ушли, в результате текущего перехода
        let completedTransitionContext = CompletedTransitionContext(
            forwardTransitionContext: fixedContext,
            sourceViewController: lastTransition.targetViewController, // откуда ушли
            sourceTransitionsHandler: animatingTransitionsHandler // кем выполнен переход
        )
        
        // создаем новую запись о переходе
        stackClient.appendTransition(
            context: completedTransitionContext,
            forTransitionsHandler: animatingTransitionsHandler
        )
    }
    
    func commitUndoingTransitionsAfter(
        transitionId transitionId: TransitionId,
        includingTransitionWithId: Bool,
        forTransitionsHandler transitionsHandler: TransitionsHandler,
        withStackClient stackClient: TransitionContextsStackClient)
    {
        stackClient.deleteTransitionsAfter(
            transitionId: transitionId,
            forTransitionsHandler: transitionsHandler,
            includingTransitionWithId: includingTransitionWithId
        )
    }
    
    func commitResettingWithTransition(
        context context: ForwardTransitionContext,
        forTransitionsHandler transitionsHandler: TransitionsHandler,
        withStackClient stackClient: TransitionContextsStackClient)
    {
        let completedTransitionContext = CompletedTransitionContext(
            forwardTransitionContext: context,
            sourceViewController: context.targetViewController, // при reset source == target
            sourceTransitionsHandler: transitionsHandler
        )
        
        // создаем новую запись о переходе
        stackClient.appendTransition(
            context: completedTransitionContext,
            forTransitionsHandler: transitionsHandler
        )
    }
}

// MARK: - assertions
private extension TransitionsCoordinator where Self: TransitionContextsStackClientProviderStorer {
    func assertAnimatorClientsOnPerformTransitionOperation(
        animatorClients animatorClients: [TransitionsHandler]?)
    {
        #if DEBUG
            guard let animatorClients = animatorClients
                else { return }
            
            for animatorClient in animatorClients {
                let stackClient = stackClientProvider.stackClient(forTransitionsHandler: animatorClient)
                if stackClient == nil {
                    assert(false, "нужно было вызывать resetWithTransition(context:). а не performTransition(context:)")
                    return
                }
            }
        #endif
    }
}