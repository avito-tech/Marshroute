import Foundation

class FirstPresenter {
    private let interactor: FirstInteractor
    private let router: FirstRouter
    
    weak var viewInput: FirstViewInput? {
        didSet {
            viewInput?.setSecondButtonEnabled(interactor.canShowSecondModule())
        }
    }
    
    //MARK: - Init
    init(interactor: FirstInteractor, router: FirstRouter){
        self.interactor = interactor
        self.router = router
    }
    
}

//MARK: - FirstInput
extension FirstPresenter: FirstModuleInput  {
    
}

//MARK: - FirstViewOutput
extension FirstPresenter: FirstViewOutput  {
    func onUserNextModule(count: Int) {
        if interactor.canShowRedModule() {
            let shouldShowRedModule = interactor.shouldShowRedModule(forCount: count)
            if shouldShowRedModule {
                router.showRedModule(0, canShowFirstModule: false, canShowSecondModule: true)
            }
            else {
                router.showWhiteModule(count, canShowFirstModule: true, canShowSecondModule: interactor.canShowSecondModule())
            }
        }
        else {
            router.showWhiteModule(count, canShowFirstModule: false, canShowSecondModule: interactor.canShowSecondModule())
        }
    }
    
    func onUserSecondModule(sender sender: AnyObject?) {
        router.showSecondModule(sender: sender)
    }
    
    func onUserDone() {
        router.askParentRouterToDismissSelf()
    }
}