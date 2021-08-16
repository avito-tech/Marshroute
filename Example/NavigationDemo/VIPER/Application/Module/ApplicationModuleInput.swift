import Foundation

protocol ApplicationModuleInput: AnyObject {
    func showAuthorizationModule(_ completion: ((_ isAuthorized: Bool) -> ())?)
}
