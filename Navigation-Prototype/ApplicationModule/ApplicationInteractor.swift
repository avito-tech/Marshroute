import Foundation

protocol ApplicationInteractor: class {
    func requestAuthorizationStatus(completion: (authorized: Bool) -> Void)
    func setAuthorizationCompletionBlock(closure: (Bool -> Void)?)
    func executeAuthorizationCompletionBlockAndDeleteAfterExecution(authorized: Bool)
}