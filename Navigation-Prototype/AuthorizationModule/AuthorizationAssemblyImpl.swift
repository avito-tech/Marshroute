import UIKit

final class AuthorizationAssemblyImpl: AuthorizationAssembly {
    
    func module() -> (UIViewController, AuthorizationModuleInput) {
        
        let interactor = AuthorizationInteractorImpl()
        let router = AuthorizationRouterImpl()
        
        let presenter = AuthorizationPresenter(
            interactor: interactor,
            router: router
        )
        
        let viewController = AuthorizationViewController(
            output: presenter
        )
        
        presenter.viewInput = viewController
        interactor.output = presenter
        
        return (viewController, presenter)
        
    }
    
}