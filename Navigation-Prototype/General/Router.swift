/**
 *  Методы, чтобы вернуться на экран текущего модуля
 */
protocol Router: class, RouterDismisable, TransitionsHandlerStorer {
    func focusOnSelf()
}

extension Router {
    func focusOnSelf() {
        transitionsHandler.undoTransitionsAfter(transitionId: transitionId)
    }
}
