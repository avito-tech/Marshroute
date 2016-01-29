import Foundation

protocol ApplicationInteractor: class {
    var isShowingAuthorizationModule: Bool { get set }
    var isAuthorized: Bool { get }
    func setAuthorizationCompletionBlock(closure: (Bool -> Void)?)
    func executeAuthorizationCompletionBlockAndDeleteAfterExecution(authorized: Bool)
}
