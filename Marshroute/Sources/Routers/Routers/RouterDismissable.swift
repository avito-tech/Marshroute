import UIKit

/// Методы, чтобы вернуться на экран модуля, показавшего экран текущего модуля
public protocol RouterDismissable: class {
    func dismissCurrentModule(completion: (() -> ())?)
}

public extension RouterDismissable {
    func dismissCurrentModule() {
        dismissCurrentModule(completion: nil)
    }
}

// MARK: - RouterDismissable Default Impl
public extension RouterDismissable where Self: RouterPresentable, Self: RouterIdentifiable {
    func dismissCurrentModule(completion: (() -> ())?)
    {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion) // дожидаемся анимации сокрытия текущего модуля
        presentingTransitionsHandler?.undoTransitionWith(transitionId: transitionId)
        CATransaction.commit()
    }
}
