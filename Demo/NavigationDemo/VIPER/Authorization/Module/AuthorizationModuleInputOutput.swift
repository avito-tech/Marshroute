import Foundation

protocol AuthorizationModuleInput: class {
    var onComplete: ((isAuthorized: Bool) -> ())? { get set }
}