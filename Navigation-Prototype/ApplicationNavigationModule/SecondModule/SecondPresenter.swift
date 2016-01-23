import Foundation

class SecondPresenter {
    private let interactor: SecondInteractor
    private let router: SecondRouter
    
    weak var viewInput: SecondViewInput? {
        didSet {
            viewInput?.setTimerTurnedOn(interactor.isTimerEnabled())
            viewInput?.setSecondsUntilTimerEnabled(0)
        }
    }
    
    //MARK: - Init
    init(interactor: SecondInteractor, router: SecondRouter){
        self.interactor = interactor
        self.router = router
    }
    
}

//MARK: - SecondInput
extension SecondPresenter: SecondModuleInput  {
    
}

//MARK: - SecondViewOutput
extension SecondPresenter: SecondViewOutput  {
    func next(sender sender: AnyObject, title: Int) {
        router.showSecondModule(sender: sender, title: title)
    }
    
    func done() {
        router.askParentRouterToDismissSelf()
    }
    
    func userDidRequestTimerLaunch() {
        viewInput?.setTimerInteractionEnabled(false)
        interactor.startTimer()
    }
}

//MARK - SecondInteractorOutput
extension SecondPresenter: SecondInteractorOutput {
    func setSecondsUntilTimerFiring(count: Int) {
        viewInput?.setSecondsUntilTimerEnabled(count)
    }
    
    func timerFired() {
        router.dismissChildModules()
        viewInput?.setTimerInteractionEnabled(true)
        viewInput?.setSecondsUntilTimerEnabled(0)
    }
}