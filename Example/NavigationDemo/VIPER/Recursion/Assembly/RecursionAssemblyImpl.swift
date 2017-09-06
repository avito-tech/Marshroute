import UIKit
import Marshroute

final class RecursionAssemblyImpl: BaseAssembly, RecursionAssembly {
    // MARK: - RecursionAssembly
    func module(routerSeed: RouterSeed)
        -> UIViewController
    {
        let router = RecursionRouterIphone(
            assemblyFactory: assemblyFactory,
            routerSeed: routerSeed
        )
        
        let isDismissable = routerSeed.presentingTransitionsHandler != nil
        
        return module(router: router, isDismissable: isDismissable)
    }
    
    func ipadModule(routerSeed: RouterSeed)
        -> UIViewController
    {
        let router = RecursionRouterIpad(
            assemblyFactory: assemblyFactory,
            routerSeed: routerSeed
        )
        
        let isDismissable = routerSeed.presentingTransitionsHandler != nil
        
        return module(router: router, isDismissable: isDismissable)
    }
    
    // MARK - Private
    fileprivate func module(router: RecursionRouter, isDismissable: Bool)
      -> UIViewController
    {
        let interactor = RecursionInteractorImpl(
            timerService: serviceFactory.timerService()
        )
        
        let presenter = RecursionPresenter(
            interactor: interactor,
            router: router
        )
        
        let viewController = RecursionViewController(
            isDismissable: isDismissable,
            peekAndPopUtility: marshrouteStack.peekAndPopUtility
        )
        
        viewController.addDisposable(presenter)
        
        presenter.view = viewController
        
        return viewController
    }
}
