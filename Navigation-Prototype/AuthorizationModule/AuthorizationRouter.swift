import Foundation

protocol AuthorizationRouter: RouterFocusable, RouterDismisable {
    func dismissWithCompletion(block: () -> Void)
}