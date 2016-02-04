import Foundation

final class ApplicationPresenter {
    private let interactor: ApplicationInteractor
    var router: ApplicationRouter?
    
    weak var viewInput: ApplicationViewInput?
    
    weak var authInput: AuthorizationModuleInput?
    
    //MARK: - Init
    init(interactor: ApplicationInteractor){
        self.interactor = interactor
    }
    
    var isShowingAuthorizationModule = false
    var authorizationCompletionBlock: (Bool -> Void)?
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
        if isShowingAuthorizationModule {
            authorizationCompletionBlock = completion
            return
        }

        interactor.requestAuthorizationStatus { [weak self] (authorized) -> Void in
            if let strongSelf = self where !authorized {
                strongSelf.isShowingAuthorizationModule = true
                strongSelf.authorizationCompletionBlock = completion
                strongSelf.router?.showAuthorization(output: strongSelf)
            }
        }
    }
}

extension ApplicationPresenter: AuthorizationModuleOutput {
    func didFinishWith(success success: Bool) {
        authorizationCompletionBlock?(success)
        authorizationCompletionBlock = nil
        isShowingAuthorizationModule = false
    }
}