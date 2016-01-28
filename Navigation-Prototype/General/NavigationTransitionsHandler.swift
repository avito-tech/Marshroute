import UIKit

class NavigationTransitionsHandler {
    
    private let navigationController: UINavigationController
    private let transitionsStackClient: TransitionContextsStackClient
    
    init(
        navigationController: UINavigationController,
        transitionsStackClient: TransitionContextsStackClient = TransitionContextsStackClient())
    {
        self.navigationController = navigationController
        self.transitionsStackClient = transitionsStackClient
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
    
    func undoTransition(fromId transitionId: TransitionId) {
        if shouldForwardUndoingTransitions(fromId: transitionId) {
            // нужно вернуться на контроллер, который не находится в истории переходов текущего обработчика
            // передаем управление дочернему обработчику
            forwardUndoingTransitions(fromId: transitionId)
        }
        else {
            // нужно вернуться на контроллер, который находится в истории переходов текущего обработчика
            // скрываем дочерние обработчики и выполняем обратный переход
            forwardUndoingAllChainedTransitionsIfNeeded()
            undoTransitionsAndCommit(fromId: transitionId)
        }
    }
    
    func undoTransition(toId transitionId: TransitionId) {
        if shouldForwardUndoingTransitions(toId: transitionId) {
            // нужно отменить переход, который не находится в истории переходов текущего обработчика
            // передаем управление дочернему обработчику
            forwardUndoingTransitions(toId: transitionId)
        }
        else {
            // нужно отменить переход, который находится в истории переходов текущего обработчика
            // скрываем дочерние обработчики и выполняем обратный переход
            forwardUndoingAllChainedTransitionsIfNeeded()
            undoTransitionAndCommit(id: transitionId)
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

// MARK: - private transitions perfroming and undoing
private extension NavigationTransitionsHandler {
    
    /**
     Геренирует новый псевдослучайный уникальный идентификатор переходаы
     */
    func generateTransitionId() -> TransitionId {
        let result = NSUUID().UUIDString
        return result
    }
    
    /**
     Осуществляет переход на новый модуль согласно описанию и сохраняет запись о переходе.
     Переход может быть отложен (например, вызовом окна авторизации)
     */
    func performTransitionAndCommit(context context: ForwardTransitionContext, transitionId: TransitionId) {
        if let sourceViewController = navigationController.topViewController,
            let animationContext = createAnimationContextForForwardTransition(context: context) {
                
                context.animator.animatePerformingTransition(animationContext: animationContext)
                
                commitPerformedTransition(
                    context: context,
                    sourceViewController: sourceViewController,
                    transitionId: transitionId
                )
                
                if context.targetTransitionsHandler !== self {
                    // показали модальное окно или поповер
                    navigationTransitionsHandlerDelegate?.navigationTransitionsHandlerDidBecomeFirstResponder(self)
                }
        }
    }
    
    /**
     Выполняет обратные переходы, пока не вернется на нужный контроллер
     */
    func undoTransitionsAndCommit(fromId transitionId: TransitionId) {
        if let lastRestoredChainedTransition = lastRestoredChainedTransition {
            // будет сокрытие модального окна или поповера
            let didFinish = lastRestoredChainedTransition.sourceViewController == context.targetViewController
            undoTransitionImpl(context: lastRestoredChainedTransition)
            commitUndoneLastTransition()
            
            // сокрытие модального окна или поповера могло сразу привести нас к нужному контроллеру
            if didFinish { return }
        }

        if let overalRestoredTransition = overalRestoredTransitionForBackwardTransition(fromId: transitionId) {
            // будет popToViewController
            undoTransitionImpl(context: overalRestoredTransition)
            commitUndoneTransitions(fromId: transitionId)
        }
    }
    
    func undoTransitionAndCommit(id transitionId: TransitionId) {

    }

    /**
     Убирает модальное окно или поповер текущего обработчика переходов
     */
    func undoChainedTransitionAndCommit() {
        if let lastRestoredChainedTransition = lastRestoredChainedTransition {
            undoTransitionImpl(context: lastRestoredChainedTransition)
            commitUndoneLastTransition()
            navigationTransitionsHandlerDelegate?.navigationTransitionsHandlerDidResignFirstResponder(self)
        }
    }
    
    /**
     Выполняет обратный переход согласно описанию (отменяет переход)
     */
    func undoTransitionImpl(context context: RestoredTransitionContext) {
        if let animationContext = createAnimationContextForRestoredTransition(context: context) {
            context.animator.animateUndoingTransition(animationContext: animationContext)
        }
    }
    
    /**
     Последовательно возвращается в начало по своей истории переходов
     */
    func undoAllTransitionsAndCommit() {
        assert(lastRestoredChainedTransition == nil, "you must undo chained transitions first")
        if let overalRestoredTransition = overalRestoredTransition {
            undoTransitionImpl(context: overalRestoredTransition)
            commitUndoneTransitions()
        }
    }
    
    func resetAllTransitionsAndCommit(withContext context: ForwardTransitionContext) {
        assert(lastRestoredChainedTransition == nil, "you must undo chained transitions first")
        if let animationContext = createAnimationContextForForwardTransition(context: context) {
            context.animator.animateResettingWithTransition(animationContext: animationContext)
        }
        commitUndoneTransitions()
    }
}

// MARK: - private transitions history management (commiting to the stack)
private extension NavigationTransitionsHandler {
    /**
     Сохраняет запись о совершенном переходе, чтобы потом иметь возможность отменить переход.
     */
    func commitPerformedTransition(
        context context: ForwardTransitionContext,
        sourceViewController: UIViewController,
        transitionId: TransitionId) {
        
        let completedTransitionContext = CompletedTransitionContext(
            forwardTransitionContext: context,
            sourceViewController: sourceViewController,
            sourceTransitionsHandler: self,
            transitionId: transitionId
        )
        completedTransitionsStack.append(completedTransitionContext)
    }
    
    func commitUndoneLastTransition() {
        completedTransitionsStack.popLast()
    }
    
    func commitUndoneTransitions() {
        completedTransitionsStack.removeAll()
    }
    
    func commitUndoneTransitions(fromId transitionId: TransitionId) {
        completedTransitionsStack.popToContext(context)
    }
}

// MARK: - permissions for forwarding to chained transition handlers
private extension NavigationTransitionsHandler {
    func canForward()
        -> Bool
    {
        let chainedTransitionsHandler = transitionsStackClient.chainedTransitionsHandlerForTransitionsHandler(self)
        let result = chainedTransitionsHandler != nil
        return result
    }
    
    func canForwardUndoing(involvingId transitionId: TransitionId)
        -> Bool
    {
        let context = transitionsStackClient.transitionWith(transitionId: transitionId, forTransitionsHandler: self)
        let result = (context == nil) && canForward()
        return result
    }
    
    func shouldForwardUndoingTransitions(fromId transitionId: TransitionId) -> Bool {
        return canForwardUndoing(involvingId: transitionId)
    }

    func shouldForwardUndoingTransitions(toId transitionId: TransitionId) -> Bool {
        return canForwardUndoing(involvingId: transitionId)
    }
}

// MARK: - forwarding to chained transition hanlders
private extension NavigationTransitionsHandler {

    func forwardPerformingTransition(@noescape contextCreationClosure closure: (generatedTransitionId: TransitionId) -> ForwardTransitionContext)
    {
        assert(canForward())
        let chainedTransitionsHandler = transitionsStackClient.chainedTransitionsHandlerForTransitionsHandler(self)
        chainedTransitionsHandler?.performTransition(contextCreationClosure: closure)
    }
    
    func forwardUndoingTransitions(fromId transitionId: TransitionId)
    {
        assert(shouldForwardUndoingTransitions(fromId: transitionId))
        let chainedTransitionsHandler = transitionsStackClient.chainedTransitionsHandlerForTransitionsHandler(self)
        chainedTransitionsHandler?.undoTransition(fromId: transitionId)
    }
    
    
    func forwardUndoingTransitions(toId transitionId: TransitionId)
    {
        assert(shouldForwardUndoingTransitions(toId: transitionId))
        let chainedTransitionsHandler = transitionsStackClient.chainedTransitionsHandlerForTransitionsHandler(self)
        chainedTransitionsHandler?.undoTransition(toId: transitionId)
    }
    
    /**
     Заставляем дочерние обработчики скрыть свои поповеры и убрать свои модальные окна
     */
    func forwardUndoingAllChainedTransitionsIfNeeded()
    {
        let chainedTransitionsHandler = transitionsStackClient.chainedTransitionsHandlerForTransitionsHandler(self)
        chainedTransitionsHandler?.undoAllChainedTransitions()
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