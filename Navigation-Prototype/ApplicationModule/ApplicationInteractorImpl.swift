import Foundation

class ApplicationInteractorImpl {
    weak var output: ApplicationPresenter?
    
    var authorizationClosure: (Bool -> Void)?
    var isShowingAuthorizationModulePrivate: Bool = false
}

//MARK: - ApplicationInteractor
extension ApplicationInteractorImpl: ApplicationInteractor  {
    var isShowingAuthorizationModule: Bool {
        get { return isShowingAuthorizationModulePrivate }
        set { isShowingAuthorizationModulePrivate = newValue }
    }
    
    var isAuthorized: Bool {
        return false // !service.isAuthorized
    }
    
    func setAuthorizationCompletionBlock(closure: (Bool -> Void)?) {
        authorizationClosure = closure
    }
    
    func executeAuthorizationCompletionBlockAndDeleteAfterExecution(authorized: Bool) {
        self.authorizationClosure?(authorized)
        self.authorizationClosure = nil
    }
}