import Foundation

class ApplicationNavigationModulePresenter {
    private let interactor: ApplicationNavigationModuleInteractor?
    private let router: ApplicationNavigationModuleRouter?
    
    weak var viewInput: ApplicationNavigationModuleViewInput?
    
    //MARK: - Init
    init(interactor: ApplicationNavigationModuleInteractor?, router: ApplicationNavigationModuleRouter?){
        self.interactor = interactor
        self.router = router
    }
    
}

//MARK: - ApplicationNavigationModuleInput
extension ApplicationNavigationModulePresenter: ApplicationNavigationModuleModuleInput  {
    
}

//MARK: - ApplicationNavigationModuleViewOutput
extension ApplicationNavigationModulePresenter: ApplicationNavigationModuleViewOutput  {
    
}