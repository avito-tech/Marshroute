import Foundation

protocol ApplicationModuleInput: class {
    func showAuthorizationModule(completion: (isAuthorized: Bool) -> Void)
}