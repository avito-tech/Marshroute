/// Методы, чтобы вернуться на экран текущего модуля
public protocol RouterFocusable: class {
    func focusOnCurrentModule()
}

// MARK: - RouterFocusable Default Impl
extension RouterFocusable where Self: RouterTransitionable, Self: RouterIdentifiable {
    public func focusOnCurrentModule() {
        transitionsHandlerBox?.unbox().undoTransitionsAfter(transitionId: transitionId)
    }
}