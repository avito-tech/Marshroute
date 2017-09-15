import Foundation

protocol ApplicationModuleInput: class {
    func showAuthorizationModule(_ completion: ((_ isAuthorized: Bool) -> ())?)
}
