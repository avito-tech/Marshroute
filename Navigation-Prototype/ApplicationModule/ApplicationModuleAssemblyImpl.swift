import Foundation

final class ApplicationModuleAssemblyImpl: ApplicationModuleAssembly {
    
    static func module() -> ApplicationModuleModule {
        
        let interactor = ApplicationModuleInteractorImpl()
        let router = ApplicationModuleRouterImpl()
        
        let presenter = ApplicationModulePresenter(
            interactor: interactor,
            router: router
        )
        
        let viewController = ApplicationModuleViewController(
            presenter: presenter
        )
        
        presenter.viewInput = viewController
        interactor.output = presenter
        
        return ApplicationModuleModule(
            view: viewController.view,
            viewController: viewController,
            moduleInput: presenter
        )
        
    }
    
}