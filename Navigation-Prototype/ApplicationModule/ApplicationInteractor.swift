import Foundation

protocol ApplicationInteractor: class {
    var shouldShowAuthorizationModule: Bool { get set }
    
    func setAuthorizationCompletionBlock(closure: (Bool -> Void)?)
    func executeAuthorizationCompletionBlockAndDeleteAfterExecution(authorized: Bool)
}
