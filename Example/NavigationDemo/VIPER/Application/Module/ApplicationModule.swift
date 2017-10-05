import Foundation

protocol ApplicationModule: class {
    func showAuthorizationModule(_ completion: ((_ isAuthorized: Bool) -> ())?)
}
