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
     и отменить все переходы внутри модуля (аналог popToRootViewController)
     */
    func undoAllTransitions()
    
    /**
     Вызывается роутером, чтобы скрыть всю последовательность дочерних модулей
     и отменить все переходы внутри модуля (аналог popToRootViewController).
     После чего подменяется корневой контроллер (аналог setViewControllers)
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