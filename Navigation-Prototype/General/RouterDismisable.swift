import Foundation

/**
 *  Методы, чтобы вернуться на экран модуля, показавшего экран текущего модуля
 */
protocol RouterDismisable: class {
    func dismissCurrentModule()
}

// MARK: - RouterDismisable Default Impl
extension RouterDismisable where Self: RouterPresentable, Self: RouterIdentifiable {
    func dismissCurrentModule() {
        presentingTransitionsHandler?.undoTransitionWith(transitionId: transitionId)
    }
}