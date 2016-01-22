import Foundation

class FirstPresenter {
    private let interactor: FirstInteractor
    private let router: FirstRouter
    
    weak var viewInput: FirstViewInput?
    
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
    func gogogo(count: Int) {
        if interactor.canChangeModule() {
            let shouldChangeModule = interactor.shouldChangeModule(forCount: count)
            if shouldChangeModule {
                router.showRedModule(0, moduleChangeable: false)
            }
            else {
                router.showWhiteModule(count, moduleChangeable: true)
            }
        }
        else {
            router.showWhiteModule(count, moduleChangeable: false)
        }
    }
}