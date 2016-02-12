/// Методы, чтобы вернуться на экран текущего модуля
protocol RouterFocusable: class {
    func focusOnCurrentModule()
}

// MARK: - RouterFocusable Default Impl
extension RouterFocusable where Self: RouterTransitionable, Self: RouterIdentifiable {
    func focusOnCurrentModule() {
        transitionsHandlerBox?.unbox().undoTransitionsAfter(transitionId: transitionId)
    }
}