import Foundation

class ApplicationInteractorImpl {
    weak var output: ApplicationPresenter?
    
    var authorizationClosure: (Bool -> Void)?
    var isShowingAuthorizationModulePrivate: Bool = false
}

//MARK: - ApplicationInteractor
extension ApplicationInteractorImpl: ApplicationInteractor  {
    func requestAuthorizationStatus(completion: (authorized: Bool) -> Void) {
        let authorized = false // service.isAuthorized
        completion(authorized: authorized)
    }
    
    func setAuthorizationCompletionBlock(closure: (Bool -> Void)?) {
        authorizationClosure = closure
    }
    
    func executeAuthorizationCompletionBlockAndDeleteAfterExecution(authorized: Bool) {
        self.authorizationClosure?(authorized)
        self.authorizationClosure = nil
    }
}