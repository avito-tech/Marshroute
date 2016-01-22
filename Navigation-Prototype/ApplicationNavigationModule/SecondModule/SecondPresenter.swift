import Foundation

class SecondPresenter {
    private let interactor: SecondInteractor?
    private let router: SecondRouter
    
    weak var viewInput: SecondViewInput?
    
    //MARK: - Init
    init(interactor: SecondInteractor?, router: SecondRouter){
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
        router.showNextSecondModule(sender: sender, title: title)
    }
    
    func done() {
        router.askParentRouterToDismissSelf()
    }
}