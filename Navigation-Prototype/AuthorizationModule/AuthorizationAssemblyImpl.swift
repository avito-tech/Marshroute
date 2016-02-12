import UIKit

final class AuthorizationAssemblyImpl: AuthorizationAssembly {
    
    func module(
        moduleOutput moduleOutput: AuthorizationModuleOutput,
        routerSeed: BaseRouterSeed)
        -> (viewController: UIViewController, moduleInput: AuthorizationModuleInput)
    {
        
        let interactor = AuthorizationInteractorImpl()
        
        let router = AuthorizationRouterImpl(routerSeed: routerSeed)
        
        let presenter = AuthorizationPresenter(
            interactor: interactor,
            router: router
        )
        
        presenter.moduleOutput = moduleOutput
        
        let viewController = AuthorizationViewController(
            output: presenter
        )
        
        presenter.viewInput = viewController
        interactor.output = presenter
        
        return (viewController, presenter)
        
    }
    
}