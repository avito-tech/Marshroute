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
        
        let viewControllerPosition = ViewControllerPosition(routerSeed: routerSeed)
        
        return module(
            router: router,
            viewControllerPosition: viewControllerPosition
        )
    }
    
    func ipadModule(routerSeed: RouterSeed)
        -> UIViewController
    {
        let router = RecursionRouterIpad(
            assemblyFactory: assemblyFactory,
            routerSeed: routerSeed
        )
        
        let viewControllerPosition = ViewControllerPosition(routerSeed: routerSeed)
        
        return module(
            router: router,
            viewControllerPosition: viewControllerPosition
        )
    }
    
    // MARK - Private
    fileprivate func module(
        router: RecursionRouter,
        viewControllerPosition: ViewControllerPosition)
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
            viewControllerPosition: viewControllerPosition,
            peekAndPopUtility: marshrouteStack.peekAndPopUtility
        )
        
        viewController.addDisposable(presenter)
        
        presenter.view = viewController
        
        return viewController
    }
}
