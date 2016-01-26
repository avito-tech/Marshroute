import UIKit

class NavigationTransitionsHandler {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    /// история переходов. в общем случае содержит переходы по стеку UINavigationController'а.
    /// может заканчиваться переходом на модальный контроллер или поповер
    private var completedTransitionsStack = TransitionContextsStack()
    
    weak var navigationTransitionsHandlerDelegate: NavigationTransitionsHandlerDelegate?
}

// MARK: - TransitionsHandler
extension NavigationTransitionsHandler : TransitionsHandler {
    
    func performTransition(context context: ForwardTransitionContext) {
        assert(context.targetTransitionsHandler != nil)
        
        if shouldForwardPerformingTransition(context: context) {
            // в цепочке обработчиков переходов есть дочерний, передаем управление ему
            forwardPerformingTransition(context: context)
        }
        else {
            // выполняем переход
            performTransitionAndCommit(context: context)
        }
    }
    
    func undoTransitions(tilContext context: BackwardTransitionContext) {
        if shouldForwardUndoingTransitions(tilContext: context) {
            // нужно вернуться на контроллер, который не находится в истории переходов текущего обработчика
            // передаем управление дочернему обработчику
            forwardUndoingTransitions(tilContext: context)
        }
        else {
            // нужно вернуться на контроллер, который находится в истории переходов текущего обработчика
            // скрываем дочерние обработчики и выполняем обратный переход
            forwardUndoingAllChainedTransitions()
            undoTransitionsAndCommit(tilContext: context)
        }
    }
    
    func undoTransition(id transitionId: TransitionId) {
        
    }
    
    func undoAllChainedTransitions() {
        forwardUndoingAllChainedTransitions()
        undoChainedTransitionAndCommit()
    }
    
    func undoAllTransitions() {
        forwardUndoingAllChainedTransitions()
        undoChainedTransitionAndCommit()
        undoAllTransitionsAndCommit()
    }
    
    func undoAllChainedTransitionsAndResetWithTransition(context: ForwardTransitionContext) {
        forwardUndoingAllChainedTransitions()
        undoChainedTransitionAndCommit()
        resetAllTransitionsAndCommit(withContext: context)
    }
}

// MARK: - private transitions perfroming and undoing
private extension NavigationTransitionsHandler {
    /**
     Осуществляет переход на новый модуль согласно описанию и сохраняет запись о переходе.
     Переход может быть отложен (например, вызовом окна авторизации)
     */
    func performTransitionAndCommit(context context: ForwardTransitionContext) {
        if let sourceViewController = navigationController.topViewController,
            let animationContext = createAnimationContextForForwardTransition(context: context) {
                
                context.animator.animatePerformingTransition(animationContext: animationContext)
                
                commitPerformedTransition(
                    context: context,
                    sourceViewController: sourceViewController
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
    func undoTransitionsAndCommit(tilContext context: BackwardTransitionContext) {
        if let lastRestoredChainedTransition = lastRestoredChainedTransition {
            let didFinish = lastRestoredChainedTransition.targetViewController == context.targetViewController
            
            // будет сокрытие модального окна или поповера
            undoTransitionImpl(context: lastRestoredChainedTransition)
            commitUndoneLastTransition()
            
            if didFinish { return }
        }

        if let overalRestoredTransition = overalRestoredTransitionForBackwardTransition(tilContext: context) {
            // будет popToViewController
            undoTransitionImpl(context: overalRestoredTransition)
            commitUndoneLastTransition()
        }
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
    func commitPerformedTransition(context context: ForwardTransitionContext, sourceViewController: UIViewController) {
        // TODO: aaa этот guard уберется тогда, когда targetTransitionsHandler станет не optional
        guard context.targetTransitionsHandler != nil
            else { assert(false); return }
                
        let completedTransitionContext = CompletedTransitionContext(
            forwardTransitionContext: context,
            sourceViewController: sourceViewController,
        sourcetrans)
        
        completedTransitionsStack.append(completedTransitionContext)
    }
    
    func commitUndoneLastTransition() {
        completedTransitionsStack.popLast()
    }
    
    func commitUndoneTransitions() {
        completedTransitionsStack.removeAll()
    }
}

// MARK: - private transitions forwarding to chained transition hanlders
private extension NavigationTransitionsHandler {
    func shouldForwardPerformingTransition(context context: ForwardTransitionContext) -> Bool {
        return lastRestoredChainedTransitionsHandler != nil
    }
    
    func forwardPerformingTransition(context context: ForwardTransitionContext) {
        assert(lastRestoredChainedTransitionsHandler != nil, "you cannot forward to nil")
        lastRestoredChainedTransitionsHandler?.performTransition(context: context)
    }
    
    func shouldForwardUndoingTransitions(tilContext context: BackwardTransitionContext) -> Bool {
        return !completedTransitionsStack.canBePoppedToContext(context)
    }
    
    func forwardUndoingTransitions(tilContext context: BackwardTransitionContext) {
        assert(lastRestoredChainedTransitionsHandler != nil, "you cannot forward to nil")
        lastRestoredChainedTransitionsHandler?.undoTransitions(tilContext: context)
    }
    
    /**
     Заставляем дочерние обработчики скрыть свои поповеры и убрать свои модальные окна
     */
    func forwardUndoingAllChainedTransitions() {
        lastRestoredChainedTransitionsHandler?.undoAllChainedTransitions()
    }
}

// MARK: - private convenience getters
private extension NavigationTransitionsHandler {
    var lastRestoredTransition: RestoredTransitionContext? {
        return completedTransitionsStack.last
    }
    
    var lastRestoredChainedTransition: RestoredTransitionContext? {
        if let lastRestoredTransition = lastRestoredTransition, let transitionsHandler = lastRestoredTransition.transitionsHandler
            where transitionsHandler !== self {
                return lastRestoredTransition
        }
        return nil
    }
    
    /// описание перехода от последнего до первого шага, минуя промежуточные
    var overalRestoredTransition: RestoredTransitionContext? {
        return completedTransitionsStack.lastToFirst
    }
    
    func overalRestoredTransitionForBackwardTransition(tilContext context: BackwardTransitionContext)
        -> RestoredTransitionContext?
    {
        return completedTransitionsStack.lastToContext(context)
    }
    
    var lastRestoredChainedTransitionsHandler: TransitionsHandler? {
        return lastRestoredChainedTransition?.transitionsHandler
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