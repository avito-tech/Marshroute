import UIKit
import Marshroute

final class AuthorizationAssemblyImpl: BaseAssembly, AuthorizationAssembly {
    // MARK: - AuthorizationAssembly
    func module(routerSeed routerSeed: RouterSeed)
        -> (viewController: UIViewController, moduleInput: AuthorizationModuleInput)
    {
        registerModuleAsBeingTracked(
            transitionsHandlerBox: routerSeed.transitionsHandlerBox,
            transitionId: routerSeed.transitionId
        )
        
        let interactor = AuthorizationInteractorImpl()
        
        let router = AuthorizationRouterIphone(
            assemblyFactory: assemblyFactory,
            routerSeed: routerSeed
        )
        
        let presenter = AuthorizationPresenter(
            interactor: interactor,
            router: router
        )
        
        let viewController = AuthorizationViewController()
        viewController.addDisposable(presenter)
        
        presenter.view = viewController
        
        return (viewController, presenter)
    }
    
    // MARK: - Private
    private func registerModuleAsBeingTracked(
        transitionsHandlerBox transitionsHandlerBox: TransitionsHandlerBox,
        transitionId: TransitionId)
    {
        // debugPrint(transitionUserId)
        
        let authorizationModuleRegisteringService = serviceFactory.authorizationModuleRegisteringService()
        
        authorizationModuleRegisteringService.registerAuthorizationModuleAsBeingTracked(
            transitionsHandlerBox: transitionsHandlerBox,
            transitionId: transitionId
        )
    }
}