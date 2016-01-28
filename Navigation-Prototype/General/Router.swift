/**
 *  Методы, чтобы вернуться на экран текущего модуля
 */
protocol Router: class, RouterDismisable, TransitionsHandlerStorer {
    func focusOnSelf()
}

extension Router {
    func focusOnSelf() {
        if let parentTransitionsHandler = parentTransitionsHandler,
            let transitionId = transitionId
        {
            parentTransitionsHandler.undoTransitionWith(transitionId: transitionId)
        }
    }
}
