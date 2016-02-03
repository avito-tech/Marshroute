import Foundation

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
        coordinateUndoingTransitionsImplAfter(
            transitionId: transitionId,
            includingTransitionWithId: false,
            forTransitionsHandler: transitionsHandler
        )
    }
    
    func coordinateUndoingTransitionWith(
        transitionId transitionId: TransitionId,
        forTransitionsHandler transitionsHandler: TransitionsHandler)
    {
        coordinateUndoingTransitionsImplAfter(
            transitionId: transitionId,
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
        let notContainerTransitionsHandlers = findNotContainerTransitionsHandlers(
            forTransitionsHandler: transitionsHandler,
            amongVisibleChildTransitionHandlers: true)
        
        // проверка, что вызван правильный метод (перед первым perform должен идти reset)
        assertAnimatorClientsOnPerformTransitionOperation(animatorClients: notContainerTransitionsHandlers)
        
        guard let selectedTransitionsHandler = selectTransitionsHandlerToPerformOrReset(
            amongTransitionsHandlers: notContainerTransitionsHandlers)
            else { return }
        
        guard let selectedAnimatingTransitionsHandler = selectedTransitionsHandler as? AnimatingTransitionsHandler
            else { return }
        
        guard let stackClient = stackClientProvider.stackClient(forTransitionsHandler: selectedAnimatingTransitionsHandler)
            else { return }
        
        // вызов анимации
        selectedAnimatingTransitionsHandler.launchAnimatingOfPerformingTransition(launchingContext: context.animationLaunchingContext)
        
        // запись об успешно совершенном переходе
        commitPerformingTransition(
            context: context,
            forTransitionsHandler: selectedAnimatingTransitionsHandler,
            withStackClient: stackClient
        )
    }
    
    func coordinateUndoingTransitionsImplAfter(
        transitionId transitionId: TransitionId,
        includingTransitionWithId: Bool,
        forTransitionsHandler transitionsHandler: TransitionsHandler)
    {
        let notContainerTransitionsHandlers = findNotContainerTransitionsHandlers(
            forTransitionsHandler: transitionsHandler,
            amongVisibleChildTransitionHandlers: false)
        
        guard let selectedTransitionsHandler = selectTransitionsHandler(
            amongTransitionsHandlers: notContainerTransitionsHandlers,
            toUndoTransitionsAfterId: transitionId,
            includingTransitionWithId: includingTransitionWithId)
            else { return }
        
        coordinateUndoingChainedTransitionsIfNeededImpl(forTransitionsHandler: transitionsHandler)
        
        guard let animatingTransitionsHandler = selectedTransitionsHandler as? AnimatingTransitionsHandler
            else { return }
        
        guard let stackClient = stackClientProvider.stackClient(forTransitionsHandler: animatingTransitionsHandler)
            else { return }
        
        let transitionsToUndo = stackClient.transitionsAfter(
            transitionId: transitionId,
            forTransitionsHandler: animatingTransitionsHandler,
            includingTransitionWithId: includingTransitionWithId
        )
        
        let chainedTransition = transitionsToUndo.chainedTransition
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
    
    func coordinateUndoingTransitionsImpl(
        chainedTransition chainedTransition: RestoredTransitionContext?,
        pushTransitions: [RestoredTransitionContext]?,
        forAnimatingTransitionsHandler animatingTransitionsHandler: AnimatingTransitionsHandler,
        andCommitUndoingTransitionsAfter transitionId: TransitionId,
        includingTransitionWithId: Bool,
        withStackClient stackClient: TransitionContextsStackClient)
    {
        // сокрытие модальных окон и поповеров, показанных внутри модальных окон и поповеров текущего обработчика
        coordinateUndoingChainedTransitionsIfNeededImpl(forTransitionsHandler: animatingTransitionsHandler)
        
        // вызов анимаций сокрытия модальных окон и поповеров
        if let animationLaunchingContext = chainedTransition?.animationLaunchingContext {
            animatingTransitionsHandler.launchAnimatingOfUndoingTransition(launchingContext: animationLaunchingContext)
        }
        
        // вызов анимаций возвращения по навигационному стеку
        if let animationLaunchingContext = pushTransitions?.first?.animationLaunchingContext {
            animatingTransitionsHandler.launchAnimatingOfUndoingTransition(launchingContext: animationLaunchingContext)
        }
        
        // запись об успешной отмене перехода (переходов)
        commitUndoingTransitionsAfter(
            transitionId: transitionId,
            includingTransitionWithId: includingTransitionWithId,
            forTransitionsHandler: animatingTransitionsHandler,
            withStackClient: stackClient
        )
    }
    
    func coordinateUndoingAllChainedTransitionsImpl(
        forTransitionsHandler transitionsHandler: TransitionsHandler)
    {
        let notContainerTransitionsHandlers = findNotContainerTransitionsHandlers(
            forTransitionsHandler: transitionsHandler,
            amongVisibleChildTransitionHandlers: true)
        
        assert(
            notContainerTransitionsHandlers?.count <= 1,
            "методы undo без transitionId посылаем только анимирующим обработчикам переходов"
        )
        
        guard let animatingTransitionsHandler = notContainerTransitionsHandlers?.first as? AnimatingTransitionsHandler
            else { assert(false); return }
        
        // сокрытие модальных окон и поповеров, показанных внутри модальных окон и поповеров текущего обработчика
        coordinateUndoingChainedTransitionsIfNeededImpl(forTransitionsHandler: animatingTransitionsHandler)
        
        assert(
            animatingTransitionsHandler === transitionsHandler,
            "методы undo без transitionId посылаем только анимирующим обработчикам переходов"
        )
        
        guard let stackClient = stackClientProvider.stackClient(forTransitionsHandler: animatingTransitionsHandler)
            else { return }
        
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
        // а на iOS 7 не использовать поповеры вообще, или использовать аккуратно:
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
        let notContainerTransitionsHandlers = findNotContainerTransitionsHandlers(
            forTransitionsHandler: transitionsHandler,
            amongVisibleChildTransitionHandlers: true)
        
        assert(
            notContainerTransitionsHandlers?.count <= 1,
            "методы undo без transitionId посылаем только анимирующим обработчикам переходов"
        )
        
        guard let animatingTransitionsHandler = notContainerTransitionsHandlers?.first as? AnimatingTransitionsHandler
            else { assert(false); return }
        
        // сокрытие модальных окон и поповеров, показанных внутри модальных окон и поповеров текущего обработчика
        coordinateUndoingChainedTransitionsIfNeededImpl(forTransitionsHandler: animatingTransitionsHandler)
        
        assert(
            animatingTransitionsHandler === transitionsHandler,
            "методы undo без transitionId посылаем только анимирующим обработчикам переходов"
        )
        
        guard let stackClient = stackClientProvider.stackClient(forTransitionsHandler: animatingTransitionsHandler)
            else { return }
        
        let transitionsToUndo = stackClient.allTransitionsForTransitionsHandler(animatingTransitionsHandler)
        let chainedTransition = transitionsToUndo.chainedTransition
        let pushTransitions = transitionsToUndo.pushTransitions
        
        guard let firstTransitionId = chainedTransition?.transitionId ?? pushTransitions?.first?.transitionId
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
        let notContainerTransitionsHandlers = findNotContainerTransitionsHandlers(
            forTransitionsHandler: transitionsHandler,
            amongVisibleChildTransitionHandlers: true)
        
        guard let selectedTransitionsHandler = selectTransitionsHandlerToPerformOrReset(
            amongTransitionsHandlers: notContainerTransitionsHandlers)
            else { return }
        
        guard let animatingTransitionsHandler = selectedTransitionsHandler as? AnimatingTransitionsHandler
            else { return }
        
        // достаем существующую историю переходов или создаем новую
        let stackClient = stackClientProvider.stackClient(forTransitionsHandler: animatingTransitionsHandler)
            ?? stackClientProvider.createStackClient(forTransitionsHandler: animatingTransitionsHandler)
        
        // вызов анимации
        animatingTransitionsHandler.launchAnimatingOfPerformingTransition(launchingContext: context.animationLaunchingContext)
        
        // запись об успешно совершенном переходе
        commitResettingWithTransition(
            context: context,
            forTransitionsHandler: animatingTransitionsHandler,
            withStackClient: stackClient
        )
    }
}

// MARK: - fetching the stack
private extension TransitionsCoordinator where Self: TransitionContextsStackClientProviderStorer {
    func findNotContainerTransitionsHandlers(
        forTransitionsHandler transitionsHandler: TransitionsHandler,
        amongVisibleChildTransitionHandlers: Bool) // false, если Undo with Id, Undo after Id
        -> [TransitionsHandler]?
    {
        var result: [TransitionsHandler]? = nil
        
        if let transitionsHandler = transitionsHandler as? TransitionsHandlersContainer {
            let nextTransitionsHandlers = (amongVisibleChildTransitionHandlers)
                // при perform, reset прокидываем только видимым обработчикам
                ? transitionsHandler.visibleTransitionsHandlers
                    // при undo прокидывание может понадобиться любому обработчику
                : transitionsHandler.allTransitionsHandlers
            
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
        else {
            result = [transitionsHandler]
        }
        
        return result
    }
    
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
        
        // если нашли несколько дочерних обработчиков на одинаковой глубине вложенности, то берем любой
        // у Split'а будет master, если ни master, ни detail не показывали модальных окон или поповеров
        if chainedTransitionsHandlers.isEmpty {
            return transitionsHandlers.first
        }
        
        return selectTransitionsHandlerToPerformOrReset(amongTransitionsHandlers: chainedTransitionsHandlers)
    }
    
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
            if stackClient.transitionWith(transitionId: transitionId, forTransitionsHandler: transitionsHandler) != nil {
                return transitionsHandler
            }
            
            // иначе смотрим дочерние обработчики
            var chainedTransitionsHandler = stackClient.chainedTransitionsHandlerForTransitionsHandler(transitionsHandler)
            
            while chainedTransitionsHandler != nil {
                guard let chainedStackClient = stackClientProvider.stackClient(forTransitionsHandler: chainedTransitionsHandler!)
                    else { break }
                
                if chainedStackClient.transitionWith(transitionId: transitionId, forTransitionsHandler: transitionsHandler) != nil {
                    return chainedTransitionsHandler
                }
                
                chainedTransitionsHandler = chainedStackClient.chainedTransitionsHandlerForTransitionsHandler(chainedTransitionsHandler!)
            }
        }
        
        return nil
    }
}

// MARK: - committing to the stack
private extension TransitionsCoordinator where Self: TransitionContextsStackClientProviderStorer {
    func commitPerformingTransition(
        context context: ForwardTransitionContext,
        forTransitionsHandler transitionsHandler: TransitionsHandler,
        withStackClient stackClient: TransitionContextsStackClient)
    {
        let fixedContext = (context.targetTransitionsHandler === transitionsHandler) // только в случае push переходов
            ? ForwardTransitionContext(context: context, changingTargetTransitionsHandler: transitionsHandler)
            : context
        
        guard let lastTransition = stackClient.lastTransitionForTransitionsHandler(transitionsHandler) else {
            assert(false, "нужно было вызывать resetWithTransition(context:). а не performTransition(context:)")
            return
        }
        
        let completedTransitionContext = CompletedTransitionContext(
            forwardTransitionContext: fixedContext,
            sourceViewController: lastTransition.targetViewController,
            sourceTransitionsHandler: transitionsHandler
        )
        
        stackClient.appendTransition(
            context: completedTransitionContext,
            forTransitionsHandler: transitionsHandler
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
        coordinateUndoingChainedTransitionsIfNeededImpl(forTransitionsHandler: transitionsHandler)
        
        let fixedContext = (context.targetTransitionsHandler === transitionsHandler) // только в случае push переходов
            ? ForwardTransitionContext(context: context, changingTargetTransitionsHandler: transitionsHandler)
            : context
        
        let completedTransitionContext = CompletedTransitionContext(
            forwardTransitionContext: fixedContext,
            sourceViewController: context.targetViewController, // при reset source == target
            sourceTransitionsHandler: transitionsHandler
        )
        
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