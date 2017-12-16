import Foundation

protocol AuthorizationOpener: class {
    func openAuthorizationModule(completion: ((_ isAuthorized: Bool) -> ())?)
}

extension AuthorizationOpener {
    func openAuthorizationModule() {
        openAuthorizationModule(completion: nil)
    }
}

protocol AuthorizationOpenerHolder: class {
    var authorizationOpener: AuthorizationOpener? { get }
}

extension AuthorizationOpener where Self: AuthorizationOpenerHolder {
    func openAuthorizationModule(completion: ((_ isAuthorized: Bool) -> ())?) {
        authorizationOpener?.openAuthorizationModule(
            completion: completion
        )
    }
}

final class WeakAuthorizationOpener: AuthorizationOpenerHolder, AuthorizationOpener {
    // MARK: - AuthorizationOpenerHolder
    weak var authorizationOpener: AuthorizationOpener?
    
    // MARK: - Init
    init(authorizationOpener: AuthorizationOpener?) {
        self.authorizationOpener = authorizationOpener
    }
}
