import Foundation

final class ApplicationPresenter {
    private let interactor: ApplicationInteractor
    var router: ApplicationRouter?
    weak var viewInput: ApplicationViewInput?
    
    private weak var authInput: AuthorizationModuleInput?
    
    //MARK: - Init
    init(interactor: ApplicationInteractor){
        self.interactor = interactor
    }
    
    private var isShowingAuthorizationModule = false
    private var authorizationCompletionBlock: (Bool -> Void)?
}

//MARK: - ApplicationInput
extension ApplicationPresenter: ApplicationModuleInput  {
    func showAuthorizationModule(completion: (isAuthorized: Bool) -> Void) {
        showAuthorizationModuleImpl(completion: completion)
    }
}

//MARK: - ApplicationViewOutput
extension ApplicationPresenter: ApplicationViewOutput  {
    func userDidRunOutOfMemory() {
        showAuthorizationModuleImpl { (isAuthorized) -> Void in
            debugPrint("==== isAuthorized ? \(isAuthorized)")
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
    
    private func showAuthorizationModuleImpl(completion completion: (isAuthorized: Bool) -> Void) {
        if isShowingAuthorizationModule {
            authorizationCompletionBlock = completion
            return
        }

        interactor.authorizationStatus { [weak self] (isAuthorized) -> Void in
            if let strongSelf = self where !isAuthorized {
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