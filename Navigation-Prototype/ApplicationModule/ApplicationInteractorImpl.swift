import Foundation

class ApplicationInteractorImpl {
    weak var output: ApplicationPresenter?
    
    var authorizationClosure: (Bool -> Void)?
    var shouldShowAuthorizationModulePrivate: Bool = true
}

//MARK: - ApplicationInteractor
extension ApplicationInteractorImpl: ApplicationInteractor  {
    var shouldShowAuthorizationModule: Bool {
        get { return shouldShowAuthorizationModulePrivate }
        set { shouldShowAuthorizationModulePrivate = newValue }
    }
    
    func setAuthorizationCompletionBlock(closure: (Bool -> Void)?) {
        authorizationClosure = closure
    }
    
    func executeAuthorizationCompletionBlockAndDeleteAfterExecution(authorized: Bool) {
        authorizationClosure?(authorized)
        authorizationClosure = nil
    }
}