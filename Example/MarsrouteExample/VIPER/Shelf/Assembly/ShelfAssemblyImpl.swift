import UIKit
import Marshroute

final class ShelfAssemblyImpl: BaseAssembly, ShelfAssembly {
    // MARK: - ShelfAssembly
    func module(routerSeed: RouterSeed)
        -> UIViewController
    {
        let interactor = ShelfInteractorImpl()
        
        let router = ShelfRouterIphone(
            assemblyFactory: assemblyFactory,
            routerSeed: routerSeed
        )
        
        let presenter = ShelfPresenter(
            interactor: interactor,
            router: router
        )
        
        let viewController = ShelfViewController()
        viewController.addDisposable(presenter)
        
        presenter.view = viewController
        
        return viewController
    }
}
