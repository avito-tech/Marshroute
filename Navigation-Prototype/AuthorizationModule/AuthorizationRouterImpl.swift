import UIKit

final class AuthorizationRouterImpl: BaseRouter, AuthorizationRouter {
    func dismissWithCompletion(block: () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(block)
        dismissCurrentModule()
        CATransaction.commit()
    }
}