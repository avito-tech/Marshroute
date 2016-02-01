import Foundation

protocol ApplicationModuleInput: class {
    func showAuthorizationModule(completion: (authed: Bool) -> Void)
}