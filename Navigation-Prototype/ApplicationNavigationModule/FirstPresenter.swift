import Foundation

class FirstPresenter {
    private let interactor: FirstInteractor?
    private let router: FirstRouter?
    
    weak var viewInput: FirstViewInput?
    
    //MARK: - Init
    init(interactor: FirstInteractor?, router: FirstRouter?){
        self.interactor = interactor
        self.router = router
    }
    
}

//MARK: - FirstInput
extension FirstPresenter: FirstModuleInput  {
    
}

//MARK: - FirstViewOutput
extension FirstPresenter: FirstViewOutput  {
    func gogogo(count: Int) {
        router?.gogogo(count)
    }
}