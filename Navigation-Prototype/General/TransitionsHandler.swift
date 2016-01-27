typealias TransitionId = String

protocol TransitionsHandler: class {
    /**
     Вызывается роутером, чтобы осуществить переход на другой модуль
     
     - parameter contextCreationClosure: блок, в который передается сгенерированный обработчиком переходов
     идентификатор перехода, и возвращающий описание параметро перехода на другой модуль
     */
    func performTransition(@noescape contextCreationClosure closure: (generatedTransitionId: TransitionId) -> ForwardTransitionContext)
    
    /**
     Вызывается роутером, чтобы отменить все переходы, следовавшие за конкретным переходом.
     Так роутер может вернуться с другого модуля на свой модуль
     */
    func undoTransitions(tilTransitionId transitionId: TransitionId)
    
    /**
     Вызывается роутером, чтобы отменить конкретный переход (и все последовавшие за ним).
     Так роутер может убрать себя с экрана
     */
    func undoTransitions(precedingTransitionId transitionId: TransitionId)
    
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
    func resetWithTransition(@noescape contextCreationClosure closure: (generatedTransitionId: TransitionId) -> ForwardTransitionContext)
}

extension TransitionsHandler {
    func performTransition(@noescape contextCreationClosure closure: (generatedTransitionId: TransitionId) -> ForwardTransitionContext) {}
    func undoTransitions(tilTransitionId transitionId: TransitionId) {}
    func undoTransitions(precedingTransitionId transitionId: TransitionId) {}
    func undoAllChainedTransitions() {}
    func undoAllTransitions() {}
    func resetWithTransition(@noescape contextCreationClosure closure: (generatedTransitionId: TransitionId) -> ForwardTransitionContext) {}
}