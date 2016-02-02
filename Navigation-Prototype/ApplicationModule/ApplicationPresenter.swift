import Foundation

class ApplicationPresenter {
    private let interactor: ApplicationInteractor
    var router: ApplicationRouter?
    
    weak var viewInput: ApplicationViewInput?
    
    weak var authInput: AuthorizationModuleInput?
    
    //MARK: - Init
    init(interactor: ApplicationInteractor){
        self.interactor = interactor
    }
}

//MARK: - ApplicationInput
extension ApplicationPresenter: ApplicationModuleInput  {
    func showAuthorizationModule(completion: (authed: Bool) -> Void) {
        showAuthorizationModuleImpl(completion: completion)
    }
}

//MARK: - ApplicationViewOutput
extension ApplicationPresenter: ApplicationViewOutput  {
    func userDidRunOutOfMemory() {
        showAuthorizationModuleImpl { (authed) -> Void in
            debugPrint("==== AUTHED ? \(authed)")
        }
    }
    
    func userDidAskTab(tab: ApplicationTabs) {
        switch tab {
        case .Three:
            showAuthorizationModuleImpl{ [weak self] (authed) -> Void in
                if authed {
                    self?.viewInput?.selectTab(tab)
                }
            }
        default:
            viewInput?.selectTab(tab)
        }
    }
    
    private func showAuthorizationModuleImpl(completion completion: (authed: Bool) -> Void) {
        if interactor.isShowingAuthorizationModule {
            interactor.setAuthorizationCompletionBlock(completion)
        }
        else if !interactor.isAuthorized {
            interactor.isShowingAuthorizationModule = true
            interactor.setAuthorizationCompletionBlock(completion)
            router?.showAuthorization(output: self)
        }
    }
}

extension ApplicationPresenter: AuthorizationModuleOutput {
    func didFinishWith(success success: Bool) {
        interactor.executeAuthorizationCompletionBlockAndDeleteAfterExecution(success)
        interactor.isShowingAuthorizationModule = false
    }
}