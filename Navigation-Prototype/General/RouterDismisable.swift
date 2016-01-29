import Foundation

/**
 *  Методы, чтобы вернуться на экран модуля, показавшего экран текущего модуля
 */
protocol RouterDismisable: class {
    func dismissCurrentModule()
}

extension RouterDismisable where Self: RouterPresentable, Self: RouterIdentifiable {
    func dismissCurrentModule() {
        presentedTransitionsHandler?.undoTransitionWith(transitionId: transitionId)
    }
}