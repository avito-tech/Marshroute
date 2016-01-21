import Foundation

class ApplicationModulePresenter {
    private let interactor: ApplicationModuleInteractor?
    private let router: ApplicationModuleRouter?
    
    weak var viewInput: ApplicationModuleViewInput?
    
    //MARK: - Init
    init(interactor: ApplicationModuleInteractor?, router: ApplicationModuleRouter?){
        self.interactor = interactor
        self.router = router
    }
    
}

//MARK: - ApplicationModuleInput
extension ApplicationModulePresenter: ApplicationModuleModuleInput  {
    
}

//MARK: - ApplicationModuleViewOutput
extension ApplicationModulePresenter: ApplicationModuleViewOutput  {
    
}