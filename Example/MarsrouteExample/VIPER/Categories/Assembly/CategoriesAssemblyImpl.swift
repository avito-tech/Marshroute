import UIKit
import Marshroute

final class CategoriesAssemblyImpl: BaseAssembly, CategoriesAssembly, SubcategoriesAssembly {
    // MARK: - CategoriesAssembly
    func module(routerSeed: RouterSeed)
        -> UIViewController
    {
        let interactor = CategoriesInteractorImpl(
            categoryId: nil,
            categoriesProvider: serviceFactory.categoriesProvider(),
            timerService: serviceFactory.timerService()
        )
        
        let router = CategoriesRouterIphone(
            assemblyFactory: assemblyFactory,
            routerSeed: routerSeed
        )
        
        let viewControllerPosition = ViewControllerPosition(routerSeed: routerSeed)
        
        return module(
            interactor: interactor,
            router: router,
            viewControllerPosition: viewControllerPosition
        )
    }
    
    func ipadModule(routerSeed: RouterSeed)
        -> UIViewController
    {
        let interactor = CategoriesInteractorImpl(
            categoryId: nil,
            categoriesProvider: serviceFactory.categoriesProvider(),
            timerService: serviceFactory.timerService()
        )
        
        let router = CategoriesRouterIpad(
            assemblyFactory: assemblyFactory,
            routerSeed: routerSeed
        )
        
        let viewControllerPosition = ViewControllerPosition(routerSeed: routerSeed)
        
        return module(
            interactor: interactor,
            router: router,
            viewControllerPosition: viewControllerPosition
        )
    }
    
    func ipadMasterDetailModule(routerSeed: MasterDetailRouterSeed)
        -> UIViewController
    {
        let interactor = CategoriesInteractorImpl(
            categoryId: nil,
            categoriesProvider: serviceFactory.categoriesProvider(),
            timerService: serviceFactory.timerService()
        )
        
        let router = CategoriesMasterDetailRouterIpad(
            assemblyFactory: assemblyFactory,
            routerSeed: routerSeed
        )
        
        let viewControllerPosition = ViewControllerPosition(masterDetailRouterSeed: routerSeed)
        
        return module(
            interactor: interactor,
            router: router,
            viewControllerPosition: viewControllerPosition
        )
    }
    
    // MARK: - SubcategoriesAssembly
    func module(categoryId: CategoryId, routerSeed: RouterSeed)
        -> UIViewController
    {
        let interactor = CategoriesInteractorImpl(
            categoryId: categoryId,
            categoriesProvider: serviceFactory.categoriesProvider(),
            timerService: nil
        )
        
        let router = CategoriesRouterIphone(
            assemblyFactory: assemblyFactory,
            routerSeed: routerSeed
        )
        
        let viewControllerPosition = ViewControllerPosition(routerSeed: routerSeed)
        
        return module(
            interactor: interactor,
            router: router,
            viewControllerPosition: viewControllerPosition
        )
    }
    
    func ipadModule(categoryId: CategoryId, routerSeed: RouterSeed)
        -> UIViewController
    {
        let interactor = CategoriesInteractorImpl(
            categoryId: categoryId,
            categoriesProvider: serviceFactory.categoriesProvider(),
            timerService: nil
        )
        
        let router = CategoriesRouterIpad(
            assemblyFactory: assemblyFactory,
            routerSeed: routerSeed
        )
        
        let viewControllerPosition = ViewControllerPosition(routerSeed: routerSeed)
        
        return module(
            interactor: interactor,
            router: router,
            viewControllerPosition: viewControllerPosition
        )
    }

    func ipadMasterDetailModule(categoryId: CategoryId, routerSeed: MasterDetailRouterSeed)
        -> UIViewController
    {
        let interactor = CategoriesInteractorImpl(
            categoryId: categoryId,
            categoriesProvider: serviceFactory.categoriesProvider(),
            timerService: nil
        )
        
        let router = CategoriesMasterDetailRouterIpad(
            assemblyFactory: assemblyFactory,
            routerSeed: routerSeed
        )
        
        let viewControllerPosition = ViewControllerPosition(masterDetailRouterSeed: routerSeed)
        
        return module(
            interactor: interactor,
            router: router,
            viewControllerPosition: viewControllerPosition
        )
    }
    
    // MARK: - Private
    fileprivate func module(
        interactor: CategoriesInteractor,
        router: CategoriesRouter,
        viewControllerPosition: ViewControllerPosition)
        -> UIViewController
    {
        let presenter = CategoriesPresenter(
            interactor: interactor,
            router: router
        )
        
        let viewController = CategoriesViewController(
            viewControllerPosition: viewControllerPosition,
            peekAndPopUtility: marshrouteStack.peekAndPopUtility
        )
        
        viewController.addDisposable(presenter)
        
        presenter.view = viewController
        
        return viewController
    }
}
