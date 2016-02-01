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
        //TODO: убрать dispatch after
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { [weak self] in
            self?.authorizationClosure?(authorized)
            self?.authorizationClosure = nil
        })
    }
}