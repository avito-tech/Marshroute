import UIKit

/**
 *  Методы, чтобы вернуться на экран модуля, показавшего экран текущего модуля
 */
protocol RouterDismisable: class {
    func dismissCurrentModule(completion completion: (() -> Void)?)
}

// MARK: - RouterDismisable Default Impl
extension RouterDismisable where Self: RouterPresentable, Self: RouterIdentifiable {
    func dismissCurrentModule(completion completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        presentingTransitionsHandler?.undoTransitionWith(transitionId: transitionId)
        CATransaction.commit()
    }
}