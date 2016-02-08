/// Действия, вызыаемые роутером для влияния на состояние навигации приложения
protocol TransitionsHandler: class {
    /// Вызывается роутером, чтобы осуществить переход на другой модуль
    func performTransition(context context: ForwardTransitionContext)
    
    /// Вызывается роутером, чтобы отменить все переходы из своего модуля и вернуться на свой модуль.
    func undoTransitionsAfter(transitionId transitionId: TransitionId)
    
    /// Вызывается роутером, чтобы отменить все переходы из своего модуля и
    /// убрать свой модуль с экрана (вернуться на предшествующий модуль)
    func undoTransitionWith(transitionId transitionId: TransitionId)
    
    /// Вызывается роутером, чтобы скрыть всю последовательность дочерних модулей,
    /// но текущий модуль оставить нетронутым
    func undoAllChainedTransitions()
    

    /// Вызывается роутером, чтобы скрыть всю последовательность дочерних модулей
    /// и отменить все переходы внутри модуля (аналог popToRootViewController).
    /// Удобно вызывать из роутера контейнера, чтобы вернуться на контроллер контейнера,
    /// потому что переходы из контейнера обычно вызываются не роутером контейнера,
    /// а роутерами содержащихся в контейнере модулей.
    func undoAllTransitions()
    
    /// Вызывается роутером, чтобы скрыть всю последовательность дочерних модулей
    /// и отменить все переходы внутри модуля (аналог popToRootViewController).
    /// После чего подменяется корневой контроллер (аналог setViewControllers:).
    /// Как правило вызывается роутером master - модуля SplitViewController'а,
    /// чтобы обновить detail
    func resetWithTransition(context context: ForwardTransitionContext)
}

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
        assert(false, "такой метод нельзя послать контейнеру обработчиков переходов. только анимирующему обработчику")
    }
    
    func undoAllTransitions() {
        assert(false, "такой метод нельзя послать контейнеру обработчиков переходов. только анимирующему обработчику")
    }
    
    func resetWithTransition(context context: ForwardTransitionContext) {
        assert(false, "такой метод нельзя послать контейнеру обработчиков переходов. только анимирующему обработчику")
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