import Foundation

final class FirstPresenter {
    private let interactor: FirstInteractor
    private let router: FirstRouter
    
    weak var viewInput: FirstViewInput? {
        didSet {
            viewInput?.setSecondButtonEnabled(interactor.canShowSecondModule())
        
            viewInput?.setTimerTurnedOn(interactor.isTimerEnabled())
            viewInput?.setSecondsUntilTimerEnabled(0)
        }
    }
    
    //MARK: - Init
    init(interactor: FirstInteractor, router: FirstRouter){
        self.interactor = interactor
        self.router = router
    }
    
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
        interactor.stopTimer()
        router.dismissCurrentModule(completion: nil)
    }
    
    func userDidRequestTimerLaunch() {
        viewInput?.setTimerInteractionEnabled(false)
        interactor.startTimer()
    }
    
    func userDidRequestAuth() {
        router.showSecondModuleIfAuthorizationSucceeds()
    }
}

//MARK - FirstInteractorOutput
extension FirstPresenter: FirstInteractorOutput {
    func setSecondsUntilTimerFiring(count: Int) {
        viewInput?.setSecondsUntilTimerEnabled(count)
    }
    
    func timerFired() {
        router.focusOnCurrentModuleAndResetDetail()
        viewInput?.setTimerInteractionEnabled(true)
        viewInput?.setSecondsUntilTimerEnabled(0)
    }
}