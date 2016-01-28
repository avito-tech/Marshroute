import UIKit

class NavigationTransitionsHandler {
    
    private let navigationController: UINavigationController
    private let stackClient: TransitionContextsStackClient
    
    init(
        navigationController: UINavigationController,
        transitionsStackClient: TransitionContextsStackClient = TransitionContextsStackClient())
    {
        self.navigationController = navigationController
        self.stackClient = transitionsStackClient
    }
    
    weak var navigationTransitionsHandlerDelegate: NavigationTransitionsHandlerDelegate?
}

// MARK: - TransitionsHandler
extension NavigationTransitionsHandler : TransitionsHandler {
    
    func performTransition(@noescape contextCreationClosure closure: (generatedTransitionId: TransitionId) -> ForwardTransitionContext) {
        if canForward() {
            // в цепочке обработчиков переходов есть дочерний, передаем управление ему
            forwardPerformingTransition(contextCreationClosure: closure)
        }
        else {
            // выполняем переход
            let transitionId = generateTransitionId()
            let context = closure(generatedTransitionId: transitionId)
            performTransitionAndCommit(context: context, transitionId: transitionId)
        }
    }
    
    func undoTransitionsAfter(transitionId transitionId: TransitionId) {
        if shouldForwardUndoingTransitionsAfter(transitionId: transitionId) {
            // нужно вернуться на контроллер, который не находится в истории переходов текущего обработчика
            // передаем управление дочернему обработчику
            forwardUndoingTransition(fromId: transitionId)
        }
        else {
            // нужно вернуться на контроллер, который находится в истории переходов текущего обработчика
            // скрываем дочерние обработчики и выполняем обратный переход
            forwardUndoingAllChainedTransitionsIfNeeded()
            undoTransitionsAfter(transitionId: transitionId)
        }
    }
    
    func undoTransitionWith(transitionId transitionId: TransitionId) {
        if shouldForwardUndoingTransitionWith(transitionId: transitionId) {
            // нужно отменить переход, который не находится в истории переходов текущего обработчика
            // передаем управление дочернему обработчику
            forwardUndoingTransitionWith(transitionId: transitionId)
        }
        else {
            // нужно отменить переход, который находится в истории переходов текущего обработчика
            // скрываем дочерние обработчики и выполняем обратный переход
            forwardUndoingAllChainedTransitionsIfNeeded()
            undoTransitionWith(transitionId: transitionId)
        }
    }
    
    func undoAllChainedTransitions() {
        forwardUndoingAllChainedTransitionsIfNeeded()
        undoChainedTransitionAndCommit()
    }
    
    func undoAllTransitions() {
        forwardUndoingAllChainedTransitionsIfNeeded()
        undoChainedTransitionAndCommit()
        undoAllTransitionsAndCommit()
    }
    
    func resetWithTransition(
        @noescape contextCreationClosure closure: (generatedTransitionId: TransitionId) -> ForwardTransitionContext)
    {
        forwardUndoingAllChainedTransitionsIfNeeded()
        undoChainedTransitionAndCommit()
        
        let transitionId = generateTransitionId()
        let context = closure(generatedTransitionId: transitionId)
        resetAllTransitionsAndCommit(withContext: context)
    }
}

// MARK: - generating transition Id
private extension NavigationTransitionsHandler {
    /**
     Геренирует новый псевдослучайный уникальный идентификатор переходаы
     */
    func generateTransitionId() -> TransitionId {
        let result = NSUUID().UUIDString
        return result
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
    func forwardPerformingTransition(@noescape contextCreationClosure closure: (generatedTransitionId: TransitionId) -> ForwardTransitionContext)
    {
        assert(canForward())
        let chainedTransitionsHandler = stackClient.chainedTransitionsHandlerForTransitionsHandler(self)
        chainedTransitionsHandler?.performTransition(contextCreationClosure: closure)
    }
    
    func forwardUndoingTransition(fromId transitionId: TransitionId)
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
    
    /**
     Заставляем дочерние обработчики скрыть свои поповеры и убрать свои модальные окна
     */
    func forwardUndoingAllChainedTransitionsIfNeeded()
    {
        let chainedTransitionsHandler = stackClient.chainedTransitionsHandlerForTransitionsHandler(self)
        chainedTransitionsHandler?.undoAllChainedTransitions()
    }
}


// MARK: - performing and undoing transitions
private extension NavigationTransitionsHandler {

    /**
     Осуществляет переход на новый модуль согласно описанию и сохраняет запись о переходе.
     Переход может быть отложен (например, вызовом окна авторизации)
     */
    func performTransitionAndCommit(context context: ForwardTransitionContext, transitionId: TransitionId) {
        if let sourceViewController = navigationController.topViewController,
            let animationContext = createAnimationContextForForwardTransition(context: context)
        {
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
    }
    
    func undo
    
    func undoTransitionsAfter(transitionId transitionId: TransitionId)
    {
        let transitionsToUndo = stackClient.transitionsFrom(
            transitionId: transitionId,
            forTransitionsHandler: self
        )
        
        if let chainedTransition = transitionsToUndo.chainedTransition {
            undoTransitionImpl(context: chainedTransition)
            // TODO: сделать тут commit, если анимации будут выполняться асинхронно
        }
        
        if let otherTransitions = transitionsToUndo.otherTransitions {
            undoTransitionsImpl(otherTransitions)
        }
        
        stackClient.deleteTransitionsFrom(
            transitionId: transitionId,
            forTransitionsHandler: self
        )
    }
    
    func undoTransitionWith(transitionId transitionId: TransitionId)
    {
        let transitionsToUndo = stackClient.transitionsFromAndTransitionWith(
            transitionId: transitionId,
            forTransitionsHandler: self
        )

        if let chainedTransition = transitionsToUndo.chainedTransition {
            undoTransitionImpl(context: chainedTransition)
            // TODO: сделать тут commit, если анимации будут выполняться асинхронно
        }
        
        if let otherTransitions = transitionsToUndo.otherTransitions {
            undoTransitionsImpl(otherTransitions)
        }
        
        stackClient.deleteTransitionsFromAndTransitionWith(
            transitionId: transitionId,
            forTransitionsHandler: self
        )
    }
    
    /**
     Убирает модальное окно или поповер текущего обработчика переходов
     */
    func undoChainedTransitionAndCommit() {
        guard let chainedContext = stackClient.chainedTransitionForTransitionsHandler(self)
            else { return }
        
        undoTransitionImpl(context: chainedContext)
        
        stackClient.deleteTransitionsFromAndTransitionWith(
            transitionId: chainedContext.transitionId,
            forTransitionsHandler: self
        )
        
        navigationTransitionsHandlerDelegate?.navigationTransitionsHandlerDidResignFirstResponder(self)
    }
    
    /**
     Выполняет обратный переход
     */
    func undoTransitionImpl(context context: RestoredTransitionContext) {
        if let animationContext = createAnimationContextForRestoredTransition(context: context) {
            context.animator.animateUndoingTransition(animationContext: animationContext)
        }
    }
    
    /**
     Выполняет обратный переход, минуя промежуточные переходы
     */
    func undoTransitionsImpl(otherTransitions: [RestoredTransitionContext]) {
        if let fromContext = otherTransitions.first {
            if let animationContext = createAnimationContextForRestoredTransition(context: fromContext) {
                fromContext.animator.animateUndoingTransition(animationContext: animationContext)
            }
        }
    }
    
    /**
     Последовательно возвращается в начало по своей истории переходов
     */
    func undoAllTransitionsAndCommit() {
        assert(stackClient.chainedTransitionsHandlerForTransitionsHandler(self) == nil, "сначала chained переходы")
        if let overalRestoredTransition = overalRestoredTransition {
            undoTransitionImpl(context: overalRestoredTransition)
            commitUndoneTransitions()
        }
    }
    
    func resetAllTransitionsAndCommit(withContext context: ForwardTransitionContext) {
        assert(stackClient.chainedTransitionsHandlerForTransitionsHandler(self) == nil, "сначала chained переходы")
        if let animationContext = createAnimationContextForForwardTransition(context: context) {
            context.animator.animateResettingWithTransition(animationContext: animationContext)
            commitUndoneTransitions()
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