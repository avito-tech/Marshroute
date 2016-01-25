import Foundation

protocol ApplicationModuleInput: class {
    func showAuthorizationModule(closure: ((authorized: Bool) -> Void)?)
}