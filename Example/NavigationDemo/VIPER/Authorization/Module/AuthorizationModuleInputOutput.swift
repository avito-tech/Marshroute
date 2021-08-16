import Foundation

protocol AuthorizationModuleInput: AnyObject {
    var onComplete: ((_ isAuthorized: Bool) -> ())? { get set }
}
