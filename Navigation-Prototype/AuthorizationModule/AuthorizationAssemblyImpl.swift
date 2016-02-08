import UIKit

final class AuthorizationAssemblyImpl: AuthorizationAssembly {
    
    func module(
        presentingTransitionsHandler: TransitionsHandler?,
        transitionId: TransitionId,
        transitionsHandler: TransitionsHandler,
        moduleOutput: AuthorizationModuleOutput,
        transitionsCoordinator: TransitionsCoordinator,
        transitionIdGenerator: TransitionIdGenerator)
        
        -> (viewController: UIViewController, moduleInput: AuthorizationModuleInput)
    {
        
        let interactor = AuthorizationInteractorImpl()
        
        let router = AuthorizationRouterImpl(
            transitionsHandler: transitionsHandler,
            transitionId: transitionId,
            presentingTransitionsHandler: presentingTransitionsHandler,
            transitionsCoordinator: transitionsCoordinator,
            transitionIdGenerator: transitionIdGenerator
        )
        
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