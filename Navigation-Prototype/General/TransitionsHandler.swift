protocol TransitionsHandler: class {
     /**
     Вызывается роутером, чтобы осуществить переход на другой модуль
     - parameter context: описание анимации перехода
     */
    func performTransition(context context: ForwardTransitionContext)
    
    /**
     Вызывается роутером, чтобы вернуться с другого модуля
     */
    func undoTransitions(tilContext context: BackwardTransitionContext)
    
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
    func undoAllTransitionsAndResetWithTransition(context: ForwardTransitionContext)
}

extension TransitionsHandler {
    func performTransition(context context: ForwardTransitionContext) {}
    func undoTransitions(tilContext context: BackwardTransitionContext) {}
    func undoAllChainedTransitions() {}
    func undoAllTransitions() {}
    func undoAllTransitionsAndResetWithTransition(context: ForwardTransitionContext) {}
}