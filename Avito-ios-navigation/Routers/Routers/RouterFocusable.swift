import UIKit

/// Методы, чтобы вернуться на экран текущего модуля
public protocol RouterFocusable: class {
    func focusOnCurrentModule(completion completion: (() -> Void)?)
}

// MARK: - RouterFocusable Default Impl
extension RouterFocusable where Self: RouterTransitionable, Self: RouterIdentifiable {
    public func focusOnCurrentModule(completion completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion) // дожидаемся анимации возвращения на текущий модуль
        transitionsHandlerBox?.unbox().undoTransitionsAfter(transitionId: transitionId)
        CATransaction.commit()
    }
}