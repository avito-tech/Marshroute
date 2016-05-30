import UIKit
import AvitoNavigation

final class RecursionAssemblyImpl: BaseAssembly, RecursionAssembly {
    // MARK: - RecursionAssembly
    func module(routerSeed routerSeed: RouterSeed)
        -> UIViewController
    {
        let router = RecursionRouterIphone(
            assemblyFactory: assemblyFactory,
            routerSeed: routerSeed
        )
        
        let isDismissable = routerSeed.presentingTransitionsHandler != nil
        
        return module(router: router, isDismissable: isDismissable)
    }
    
    func ipadModule(routerSeed routerSeed: RouterSeed)
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
    private func module(router router: RecursionRouter, isDismissable: Bool)
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
            isDismissable: isDismissable
        )
        
        viewController.addDisposable(presenter)
        
        presenter.view = viewController
        
        return viewController
    }
}
