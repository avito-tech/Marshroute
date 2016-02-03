import Foundation
import UIKit

protocol TransitionsHandler: class {
    /**
     Вызывается роутером, чтобы осуществить переход на другой модуль
     */
    func performTransition(context context: ForwardTransitionContext)
    
    /**
     Вызывается роутером, чтобы отменить все переходы из своего модуля и вернуться на свой модуль.
     */
    func undoTransitionsAfter(transitionId transitionId: TransitionId)
    
    /**
     Вызывается роутером, чтобы отменить все переходы из своего модуля и
     убрать свой модуль с экрана (вернуться на предшествующий модуль)
     */
    func undoTransitionWith(transitionId transitionId: TransitionId)
    
    /**
     Вызывается роутером, чтобы скрыть всю последовательность дочерних модулей,
     но текущий модуль оставить нетронутым
     */
    func undoAllChainedTransitions()
    
    /**
     Вызывается роутером, чтобы скрыть всю последовательность дочерних модулей
     и отменить все переходы внутри модуля (аналог popToRootViewController).
     Удобно вызывать из роутера контейнера, чтобы вернуться на контроллер контейнера,
     потому что переходы из контейнера обычно вызываются не роутером контейнера,
     а роутерами содержащихся в контейнере модулей.
     */
    func undoAllTransitions()
    
    /**
     Вызывается роутером, чтобы скрыть всю последовательность дочерних модулей
     и отменить все переходы внутри модуля (аналог popToRootViewController).
     После чего подменяется корневой контроллер (аналог setViewControllers:).
     Как правило вызывается роутером master - модуля SplitViewController'а,
     чтобы обновить detail
     */
    func resetWithTransition(context context: ForwardTransitionContext)
}

protocol TransitionsCoordinatorStorer: class {
    var transitionsCoordinator: TransitionsCoordinator { get }
}

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

//
// MARK: - TransitionsHandler Default Impl 1 (for containers: i.e. split or tabbar transitions handlers)
extension TransitionsHandler where Self: TransitionsCoordinatorStorer, Self: TransitionsHandlersContainer {
    func performTransition(context context: ForwardTransitionContext) {
        transitionsCoordinator.coordinatePerformingTransition(context: context, forTransitionsHandler: self)
    }
    
    func undoTransitionsAfter(transitionId transitionId: TransitionId) {
        transitionsCoordinator.coordinateUndoingTransitionsAfter(transitionId: transitionId, forTransitionsHandler: self)
    }
    
    func undoTransitionWith(transitionId transitionId: TransitionId) {
        transitionsCoordinator.coordinateUndoingTransitionWith(transitionId: transitionId, forTransitionsHandler: self)
    }
    
    func undoAllChainedTransitions() {
        assert(false, "такой метод нельзя послать контейнеру обработчиков переходов. только листовому обработчику")
    }
    
    func undoAllTransitions() {
        assert(false, "такой метод нельзя послать контейнеру обработчиков переходов. только листовому обработчику")
    }
    
    func resetWithTransition(context context: ForwardTransitionContext) {
        assert(false, "такой метод нельзя послать контейнеру обработчиков переходов. только листовому обработчику")
    }
}

// MARK: - TransitionsHandler Default Impl 2 (for not containers: i.e. navigation transitions handlers)
extension TransitionsHandler where Self: TransitionsCoordinatorStorer, Self: TransitionsAnimatorClient {
    func performTransition(context context: ForwardTransitionContext) {
        transitionsCoordinator.coordinatePerformingTransition(context: context, forTransitionsHandler: self)
    }
    
    func undoTransitionsAfter(transitionId transitionId: TransitionId) {
        transitionsCoordinator.coordinateUndoingTransitionsAfter(transitionId: transitionId, forTransitionsHandler: self)
    }
    
    func undoTransitionWith(transitionId transitionId: TransitionId) {
        transitionsCoordinator.coordinateUndoingTransitionWith(transitionId: transitionId, forTransitionsHandler: self)
    }
    
    func undoAllChainedTransitions() {
        transitionsCoordinator.coordinateUndoingAllChainedTransitions(forTransitionsHandler: self)
    }
    
    func undoAllTransitions() {
        transitionsCoordinator.coordinateUndoingAllTransitions(forTransitionsHandler: self)
    }
    
    func resetWithTransition(context context: ForwardTransitionContext) {
        transitionsCoordinator.coordinateResettingWithTransition(context: context, forTransitionsHandler: self)
    }
}

protocol TransitionsHandlersContainer: class {
    var allTransitionsHandlers: [TransitionsHandler] { get }
    var visibleTransitionsHandlers: [TransitionsHandler] { get }
}

protocol TransitionsAnimatorClient: class {
    func launchAnimatingOfPerformingTransition(launchingContext context: TransitionAnimationLaunchingContext)
    func launchAnimatingOfUndoingTransition(launchingContext context: TransitionAnimationLaunchingContext)
    func launchAnimatingOfResettingWithTransition(launchingContext context: TransitionAnimationLaunchingContext)
}

protocol TransitionContextsStackClientProvider: class {
    func stackClient(forTransitionsHandler transitionsHandler: TransitionsHandler) -> TransitionContextsStackClient?
    func createStackClient(forTransitionsHandler transitionsHandler: TransitionsHandler) -> TransitionContextsStackClient
}

protocol TransitionContextsStackClientProviderStorer: class {
    var stackClientProvider: TransitionContextsStackClientProvider { get }
}

extension TransitionsCoordinator where Self: TransitionContextsStackClientProviderStorer {
    typealias AnimatingTransitionsHandler = protocol<TransitionsHandler, TransitionsAnimatorClient>
    
    func coordinatePerformingTransition(
        context context: ForwardTransitionContext,
        forTransitionsHandler transitionsHandler: TransitionsHandler)
    {
        let notContainerTransitionsHandlers = findNotContainerTransitionsHandlers(
            forTransitionsHandler: transitionsHandler,
            amongVisibleChildTransitionHandlers: true)
        
        // проверка, что вызван правильный метод (перед первым perform должен идти reset)
        assertAnimatorClientsOnPerformTransitionOperation(animatorClients: notContainerTransitionsHandlers)
        
        guard let selectedTransitionsHandler = selectTransitionsHandlerToPerformOrReset(amongTransitionsHandlers: notContainerTransitionsHandlers)
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
    
    func coordinateUndoingTransitionsAfter(
        transitionId transitionId: TransitionId,
        forTransitionsHandler transitionsHandler: TransitionsHandler)
    {
        coordinateUndoingTransitionsAfter(
            transitionId: transitionId,
            includingTransitionWithId: false,
            forTransitionsHandler: transitionsHandler
        )
    }
    
    func coordinateUndoingTransitionWith(
        transitionId transitionId: TransitionId,
        forTransitionsHandler transitionsHandler: TransitionsHandler)
    {
        coordinateUndoingTransitionsAfter(
            transitionId: transitionId,
            includingTransitionWithId: true,
            forTransitionsHandler: transitionsHandler
        )
    }
    
    func coordinateUndoingAllChainedTransitions(
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
        
        assert(
            animatingTransitionsHandler === transitionsHandler,
            "методы undo без transitionId посылаем только анимирующим обработчикам переходов"
        )
        
        guard let stackClient = stackClientProvider.stackClient(forTransitionsHandler: animatingTransitionsHandler)
            else { return }
        
        guard let chainedTransition = stackClient.chainedTransitionForTransitionsHandler(animatingTransitionsHandler)
            else { return }
        
        coordinateUndoingTransitions(
            chainedTransition: chainedTransition,
            pushTransitions: nil,
            forTransitionsAnimatorClient: animatingTransitionsHandler,
            andCommitUndoingTransitionsAfter: chainedTransition.transitionId,
            includingTransitionWithId: true,
            withStackClient: stackClient
        )
    }
    
    func coordinateUndoingAllTransitions(
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
        
        coordinateUndoingTransitions(
            chainedTransition: chainedTransition,
            pushTransitions: pushTransitions,
            forTransitionsAnimatorClient: animatingTransitionsHandler,
            andCommitUndoingTransitionsAfter: firstTransitionId,
            includingTransitionWithId: false,
            withStackClient: stackClient
        )
    }
    
    func coordinateResettingWithTransition(
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

// MARK: - helpers
private extension TransitionsCoordinator where Self: TransitionContextsStackClientProviderStorer {
    func coordinateUndoingTransitionsAfter(
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
        
        guard let animatingTransitionsHandler = selectedTransitionsHandler as? AnimatingTransitionsHandler
            else { return }
        
        guard let stackClient = stackClientProvider.stackClient(forTransitionsHandler: animatingTransitionsHandler)
            else { return }
        
        let transitionsToUndo = stackClient.transitionsAfter(
            transitionId: transitionId,
            forTransitionsHandler: animatingTransitionsHandler,
            includingTransitionWithId: includingTransitionWithId
        )
        
        let chainedTransitionContext = transitionsToUndo.chainedTransition
        let pushTransitionContexts = transitionsToUndo.pushTransitions
        
        // вызов анимаций сокрытия модальных окон и поповеров
        if let animationLaunchingContext = chainedTransitionContext?.animationLaunchingContext {
            animatingTransitionsHandler.launchAnimatingOfUndoingTransition(launchingContext: animationLaunchingContext)
        }
        
        // вызов анимаций возвращения по навигационному стеку
        if let animationLaunchingContext = pushTransitionContexts?.first?.animationLaunchingContext {
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
    
    func coordinateUndoingTransitions
        (chainedTransition chainedTransition: RestoredTransitionContext?,
        pushTransitions: [RestoredTransitionContext]?,
        forTransitionsAnimatorClient animatorClient: AnimatingTransitionsHandler,
        andCommitUndoingTransitionsAfter transitionId: TransitionId,
        includingTransitionWithId: Bool,
        withStackClient stackClient: TransitionContextsStackClient)
    {
        // вызов анимаций сокрытия модальных окон и поповеров
        if let animationLaunchingContext = chainedTransition?.animationLaunchingContext {
            animatorClient.launchAnimatingOfUndoingTransition(launchingContext: animationLaunchingContext)
        }
        
        // вызов анимаций возвращения по навигационному стеку
        if let animationLaunchingContext = pushTransitions?.first?.animationLaunchingContext {
            animatorClient.launchAnimatingOfUndoingTransition(launchingContext: animationLaunchingContext)
        }
        
        // запись об успешной отмене перехода (переходов)
        commitUndoingTransitionsAfter(
            transitionId: transitionId,
            includingTransitionWithId: includingTransitionWithId,
            forTransitionsHandler: animatorClient,
            withStackClient: stackClient
        )
    }
    
    func findNotContainerTransitionsHandlers(
        forTransitionsHandler transitionsHandler: TransitionsHandler,
        amongVisibleChildTransitionHandlers: Bool) // false, если Undo. true если Perform, Reset
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