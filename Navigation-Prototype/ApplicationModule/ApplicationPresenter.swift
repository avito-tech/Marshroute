import Foundation

class ApplicationPresenter {
    private let interactor: ApplicationInteractor
    private let router: ApplicationRouter
    
    weak var navigationModuleInput: ApplicationNavigationModuleInput?
    
    //MARK: - Init
    init(interactor: ApplicationInteractor, router: ApplicationRouter){
        self.interactor = interactor
        self.router = router
    }
    
}

//MARK: - ApplicationInput
extension ApplicationPresenter: ApplicationModuleInput  {
    
}

//MARK: - ApplicationViewOutput
extension ApplicationPresenter: ApplicationViewOutput  {
    
}