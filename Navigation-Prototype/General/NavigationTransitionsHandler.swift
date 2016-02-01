import UIKit

class NavigationTransitionsHandler {
    
    private unowned let navigationController: UINavigationController
    private let stackClient: TransitionContextsStackClient
    
    init(
        navigationController: UINavigationController,
        transitionsStackClient: TransitionContextsStackClient = TransitionContextsStackClientImpl())
    {
        self.navigationController = navigationController
        self.stackClient = transitionsStackClient
    }
    
    weak var navigationTransitionsHandlerDelegate: NavigationTransitionsHandlerDelegate?
}

// MARK: - TransitionsHandler
extension NavigationTransitionsHandler : TransitionsHandler {
    func performTransition(context context: ForwardTransitionContext)
    {
        if canForward() {
            // в цепочке обработчиков переходов есть дочерний, передаем управление ему
            forwardPerformingTransition(context: context)
        }
        else {
            // выполняем переход
            performTransitionImpl(context: context)
        }
    }
    
    func undoTransitionsAfter(transitionId transitionId: TransitionId)
    {
        if shouldForwardUndoingTransitionsAfter(transitionId: transitionId) {
            // нужно вернуться на контроллер, который не находится в истории переходов текущего обработчика
            // передаем управление дочернему обработчику
            forwardUndoingTransitionsAfter(transitionId: transitionId)
        }
        else {
            // нужно вернуться на контроллер, который находится в истории переходов текущего обработчика
            // скрываем дочерние обработчики и выполняем обратный переход
            forwardUndoingAllChainedTransitionsIfNeeded()
            undoTransitionsAfter(transitionId: transitionId, includingTransitionWithId: false)
        }
    }
    
    func undoTransitionWith(transitionId transitionId: TransitionId)
    {
        if shouldForwardUndoingTransitionWith(transitionId: transitionId) {
            // нужно отменить переход, который не находится в истории переходов текущего обработчика
            // передаем управление дочернему обработчику
            forwardUndoingTransitionWith(transitionId: transitionId)
        }
        else {
            // нужно отменить переход, который находится в истории переходов текущего обработчика
            // скрываем дочерние обработчики и выполняем обратный переход
            forwardUndoingAllChainedTransitionsIfNeeded()
            undoTransitionsAfter(transitionId: transitionId, includingTransitionWithId: true)
        }
    }
    
    func undoAllChainedTransitions()
    {
        forwardUndoingAllChainedTransitionsIfNeeded()
        undoChainedTransitionIfNeeded()
    }
    
    func undoAllTransitions()
    {
        forwardUndoingAllChainedTransitionsIfNeeded()
        undoAllTransitionsImpl()
    }
    
    func resetWithTransition(context context: ForwardTransitionContext)
    {
        forwardUndoingAllChainedTransitionsIfNeeded()
        undoChainedTransitionIfNeeded()
        resetWithTransitionImpl(context: context)
    }
}

// MARK: - permissions for forwarding to chained transition handlers
private extension NavigationTransitionsHandler {
    func canForward()
        -> Bool
    {
        let chainedTransitionsHandler = stackClient.chainedTransitionsHandlerForTransitionsHandler(self)
        let result = chainedTransitionsHandler != nil
        return result
    }
    
    func canForwardUndoingTransitions(involvingId transitionId: TransitionId)
        -> Bool
    {
        let context = stackClient.transitionWith(transitionId: transitionId, forTransitionsHandler: self)
        let result = (context == nil) && canForward()
        return result
    }
    
    func shouldForwardUndoingTransitionsAfter(transitionId transitionId: TransitionId)
        -> Bool
    {
        let result = canForwardUndoingTransitions(involvingId: transitionId)
        return result
    }
    
    func shouldForwardUndoingTransitionWith(transitionId transitionId: TransitionId)
        -> Bool
    {
        let result = canForwardUndoingTransitions(involvingId: transitionId)
        return result
    }
}

// MARK: - forwarding to chained transition hanlders
private extension NavigationTransitionsHandler {
    func forwardPerformingTransition(context context: ForwardTransitionContext)
    {
        assert(canForward())

        guard let chainedTransitionsHandler = stackClient.chainedTransitionsHandlerForTransitionsHandler(self)
            else { return }
        
        // при пробрасывании push переходов нужно обновлять ссылку на обработчика переходов показываемого модуля
        let contextToForward = (context.targetTransitionsHandler === self) // только в случае push переходов
        ? ForwardTransitionContext(context: context, forwardedTotransitionsHandler: chainedTransitionsHandler)
        : context
        
        chainedTransitionsHandler.performTransition(context: contextToForward)
    }
    
    func forwardUndoingTransitionsAfter(transitionId transitionId: TransitionId)
    {
        assert(shouldForwardUndoingTransitionsAfter(transitionId: transitionId))
        let chainedTransitionsHandler = stackClient.chainedTransitionsHandlerForTransitionsHandler(self)
        chainedTransitionsHandler?.undoTransitionsAfter(transitionId: transitionId)
    }
    
    func forwardUndoingTransitionWith(transitionId transitionId: TransitionId)
    {
        assert(shouldForwardUndoingTransitionWith(transitionId: transitionId))
        let chainedTransitionsHandler = stackClient.chainedTransitionsHandlerForTransitionsHandler(self)
        chainedTransitionsHandler?.undoTransitionWith(transitionId: transitionId)
    }
    
    func forwardUndoingAllChainedTransitionsIfNeeded()
    {
        let chainedTransitionsHandler = stackClient.chainedTransitionsHandlerForTransitionsHandler(self)
        chainedTransitionsHandler?.undoAllChainedTransitions()
    }
}


// MARK: - performing and undoing transitions
private extension NavigationTransitionsHandler {
    func performTransitionImpl(context context: ForwardTransitionContext)
    {
        assert(!canForward())
        
        guard let sourceViewController = navigationController.topViewController
            else { return }
        guard let animationContext = createAnimationContextForForwardTransition(context: context)
            else { return }
        
        context.animator.animatePerformingTransition(animationContext: animationContext)
        
        let completedTransitionContext = CompletedTransitionContext(
            forwardTransitionContext: context,
            sourceViewController: sourceViewController,
            sourceTransitionsHandler: self
        )
        
        stackClient.appendTransition(
            context: completedTransitionContext,
            forTransitionsHandler: self
        )
        
        if context.targetTransitionsHandler !== self {
            // показали модальное окно или поповер
            navigationTransitionsHandlerDelegate?.navigationTransitionsHandlerDidBecomeFirstResponder(self)
        }
    }

    func undoTransitionsAfter(
        transitionId transitionId: TransitionId,
        includingTransitionWithId: Bool)
    {
        let transitionsToUndo = stackClient.transitionsAfter(
            transitionId: transitionId,
            forTransitionsHandler: self,
            includingTransitionWithId: includingTransitionWithId
        )
        
        undoTransitionsImpl(
            chainedContext: transitionsToUndo.chainedTransition,
            pushContexts: transitionsToUndo.pushTransitions,
            andCommitUndoingTransitionsAfter: transitionId,
            includingTransitionWithId: includingTransitionWithId
        )
    }
    
    func undoChainedTransitionIfNeeded()
    {
        guard let chainedTransitionContext = stackClient.chainedTransitionForTransitionsHandler(self)
            else { return }

        undoTransitionsImpl(
            chainedContext: chainedTransitionContext,
            pushContexts: nil,
            andCommitUndoingTransitionsAfter: chainedTransitionContext.transitionId,
            includingTransitionWithId: true
        )
    }

    func undoAllTransitionsImpl()
    {
        let transitionsToUndo = stackClient.allTransitionsForTransitionsHandler(self)
        let chainedTransitionContext = transitionsToUndo.chainedTransition
        let pushTransitions = transitionsToUndo.pushTransitions
        
        guard let leftmostTransitionId = chainedTransitionContext?.transitionId ?? pushTransitions?.first?.transitionId
            else { return }
        
        undoTransitionsImpl(
            chainedContext: transitionsToUndo.chainedTransition,
            pushContexts: transitionsToUndo.pushTransitions,
            andCommitUndoingTransitionsAfter: leftmostTransitionId,
            includingTransitionWithId: false
        )
    }

    func undoTransitionsImpl(
        chainedContext chainedContext: RestoredTransitionContext?,
        pushContexts: [RestoredTransitionContext]?,
        andCommitUndoingTransitionsAfter transitionId: TransitionId,
        includingTransitionWithId: Bool)
    {
        if let chainedContext = chainedContext {
            undoTransitionImpl(context: chainedContext)
            navigationTransitionsHandlerDelegate?.navigationTransitionsHandlerDidResignFirstResponder(self)
            // TODO: сделать тут commit, если анимации будут выполняться асинхронно
        }
        
        if let pushContexts = pushContexts {
            undoTransitionsPassingIntermediateTransitions(pushContexts)
        }
        
        stackClient.deleteTransitionsAfter(
            transitionId: transitionId,
            forTransitionsHandler: self,
            includingTransitionWithId: includingTransitionWithId
        )
    }

    func undoTransitionImpl(context context: RestoredTransitionContext)
    {
        if let animationContext = createAnimationContextForRestoredTransition(context: context) {
            context.animator.animateUndoingTransition(animationContext: animationContext)
        }
    }
    
    func undoTransitionsPassingIntermediateTransitions(pushTransitions: [RestoredTransitionContext])
    {
        if let fromContext = pushTransitions.first { // минуем промежуточные переходы
            undoTransitionImpl(context: fromContext)
        }
    }
    
    func resetWithTransitionImpl(context context: ForwardTransitionContext)
    {
        assert(
            stackClient.chainedTransitionForTransitionsHandler(self) == nil,
            "сначала chained (aka не push) переходы"
        )
        
        guard let animationContext = createAnimationContextForForwardTransition(context: context)
            else { return }
        
        context.animator.animateResettingWithTransition(animationContext: animationContext)
        
        let completedTransitionContext = CompletedTransitionContext(
            forwardTransitionContext: context,
            sourceViewController: context.targetViewController, // при reset source === target
            sourceTransitionsHandler: self
        )
        
        stackClient.appendTransition(
            context: completedTransitionContext,
            forTransitionsHandler: self
        )
    }
}

// MARK: - private animation parameters creating
private extension NavigationTransitionsHandler {
    
    @warn_unused_result
    func createAnimationSourceParameters(
        transitionStyle transitionStyle: TransitionStyle,
        storableParameters: TransitionStorableParameters?) -> TransitionAnimationSourceParameters? {
        
        switch transitionStyle {
        case .Push, .Modal:
            let result = NavigationAnimationSourceParameters(navigationController: navigationController)
            return result
            
        case .PopoverFromButtonItem(_), .PopoverFromView(_, _):
            guard let popoverStorableParameters = storableParameters as? PopoverTransitionStorableParameters else {
                assert(false, "You passed wrong storable parameters \(storableParameters) for transition style: \(transitionStyle)")
                return nil
            }
            
            guard let popoverController = popoverStorableParameters.popoverController else {
                assert(false, "You passed wrong storable parameters \(storableParameters) for transition style: \(transitionStyle)")
                return nil
            }
            
            let result = PopoverAnimationSourceParameters(popoverController: popoverController)
            return result
        }
    }
    
    @warn_unused_result
    func createAnimationContextForForwardTransition(context context: ForwardTransitionContext) -> TransitionAnimationContext? {
        guard let animationSourceParameters = createAnimationSourceParameters(
            transitionStyle: context.transitionStyle,
            storableParameters: context.storableParameters)
            else { return nil }
        
        let converter = TransitionContextConverter()
        let result = converter.convertForwardTransition(
            context: context,
            toAnimationContextWithAnimationSourceParameters: animationSourceParameters)
        
        return result
    }
    
    @warn_unused_result
    func createAnimationContextForRestoredTransition(context context: RestoredTransitionContext) -> TransitionAnimationContext? {
        guard let animationSourceParameters = createAnimationSourceParameters(
            transitionStyle: context.transitionStyle,
            storableParameters: context.storableParameters)
            else { return nil }
        
        let converter = TransitionContextConverter()
        let result = converter.convertRestoredTransition(
            context: context,
            toAnimationContextWithAnimationSourceParameters: animationSourceParameters)
        
        return result
    }
}