import UIKit

class NavigationTransitionsHandler {
    
    private let navigationController: UINavigationController
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
        undoAllTransitionsIfNeeded()
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
        let chainedTransitionsHandler = stackClient.chainedTransitionsHandlerForTransitionsHandler(self)
        chainedTransitionsHandler?.performTransition(context: context)
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
    func performTransitionImpl(context context: ForwardTransitionContext) {
        assert(!canForward())
        debugPrint(context.transitionId)
        
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
        
        undoTransitions(
            chainedContext: transitionsToUndo.chainedTransition,
            otherContexts: transitionsToUndo.otherTransitions,
            andCommitUndoingTransitionsAfter: transitionId,
            includingTransitionWithId: includingTransitionWithId
        )
    }
    
    func undoChainedTransitionIfNeeded() {
        guard let chainedTransitionContext = stackClient.chainedTransitionForTransitionsHandler(self)
            else { return }

        undoTransitions(
            chainedContext: chainedTransitionContext,
            otherContexts: nil,
            andCommitUndoingTransitionsAfter: chainedTransitionContext.transitionId,
            includingTransitionWithId: true
        )
    }

    func undoAllTransitionsIfNeeded() {
        let transitionsToUndo = stackClient.allTransitionsForTransitionsHandler(self)
        let chainedTransitionContext = transitionsToUndo.chainedTransition
        let otherTransitions = transitionsToUndo.otherTransitions
        
        guard let leftmostTransitionId = chainedTransitionContext?.transitionId ?? otherTransitions?.first?.transitionId
            else { return }
        
        undoTransitions(
            chainedContext: transitionsToUndo.chainedTransition,
            otherContexts: transitionsToUndo.otherTransitions,
            andCommitUndoingTransitionsAfter: leftmostTransitionId,
            includingTransitionWithId: false
        )
    }

    func undoTransitions(
        chainedContext chainedContext: RestoredTransitionContext?,
        otherContexts: [RestoredTransitionContext]?,
        andCommitUndoingTransitionsAfter transitionId: TransitionId,
        includingTransitionWithId: Bool)
    {
        if let chainedTransitionContext = chainedContext {
            undoTransition(context: chainedTransitionContext)
            navigationTransitionsHandlerDelegate?.navigationTransitionsHandlerDidResignFirstResponder(self)
            // TODO: сделать тут commit, если анимации будут выполняться асинхронно
        }
        
        if let otherTransitionContexts = otherContexts {
            undoTransitionsPassingIntermediateTransitions(otherTransitionContexts)
        }
        
        stackClient.deleteTransitionsAfter(
            transitionId: transitionId,
            forTransitionsHandler: self,
            includingTransitionWithId: includingTransitionWithId
        )
    }

    func undoTransition(context context: RestoredTransitionContext) {
        if let animationContext = createAnimationContextForRestoredTransition(context: context) {
            context.animator.animateUndoingTransition(animationContext: animationContext)
        }
    }
    
    func undoTransitionsPassingIntermediateTransitions(otherTransitions: [RestoredTransitionContext]) {
        if let fromContext = otherTransitions.first { // минуем промежуточные переходы
            undoTransition(context: fromContext)
        }
    }
    
    func resetWithTransitionImpl(context context: ForwardTransitionContext)
    {
        assert(stackClient.chainedTransitionForTransitionsHandler(self) == nil, "сначала chained переходы")
        debugPrint(context.transitionId)
        
        if let animationContext = createAnimationContextForForwardTransition(context: context) {
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
            
            let popoverController = popoverStorableParameters.popoverController
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