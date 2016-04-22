import UIKit

/// Методы, чтобы вернуться на экран модуля, показавшего экран текущего модуля
public protocol RouterDismisable: class {
    func dismissCurrentModule(completion completion: (() -> Void)?)
}

// MARK: - RouterDismisable Default Impl
public extension RouterDismisable where Self: RouterPresentable, Self: RouterIdentifiable {
    func dismissCurrentModule(completion completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion) // дожидаемся анимации сокрытия текущего модуля
        presentingTransitionsHandler?.undoTransitionWith(transitionId: transitionId)
        CATransaction.commit()
    }
    
    func dismissCurrentModule() {
        dismissCurrentModule(completion: nil)
    }
}