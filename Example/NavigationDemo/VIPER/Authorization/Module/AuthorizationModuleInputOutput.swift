import Foundation

protocol AuthorizationModuleInput: class {
    var onComplete: ((_ isAuthorized: Bool) -> ())? { get set }
}
