import UIKit
import Marshroute

final class ShelfAssemblyImpl: BaseAssembly, ShelfAssembly {
    // MARK: - ShelfAssembly
    func module(
        style: ShelfStyle,
        routerSeed: RouterSeed)
        -> (ShelfModule, UIViewController)
    {
        let interactor = ShelfInteractorImpl()
        
        let router = ShelfRouterIphone(
            assemblyFactory: assemblyFactory,
            routerSeed: routerSeed
        )
        
        let presenter = ShelfPresenter(
            style: style,
            interactor: interactor,
            router: router
        )
        
        let viewController = ShelfViewController(
            style: style
        )
        viewController.addDisposable(presenter)
        
        presenter.view = viewController
        
        return (presenter, viewController)
    }
}
