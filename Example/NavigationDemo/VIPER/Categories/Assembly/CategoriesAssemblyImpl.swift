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
        
        let isDismissable = routerSeed.presentingTransitionsHandler != nil
        
        return module(interactor: interactor, router: router, isDismissable: isDismissable)
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
        
        let isDismissable = routerSeed.presentingTransitionsHandler != nil
        
        return module(interactor: interactor, router: router, isDismissable: isDismissable)
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
        
        let isDismissable = routerSeed.presentingTransitionsHandler != nil
        
        return module(interactor: interactor, router: router, isDismissable: isDismissable)
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
        
        return module(interactor: interactor, router: router, isDismissable: false)
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
        
        return module(interactor: interactor, router: router, isDismissable: false)
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
        
        return module(interactor: interactor, router: router, isDismissable: false)
    }
    
    // MARK: - Private
    fileprivate func module(interactor: CategoriesInteractor, router: CategoriesRouter, isDismissable: Bool)
        -> UIViewController
    {
        let presenter = CategoriesPresenter(
            interactor: interactor,
            router: router
        )
        
        let viewController = CategoriesViewController(
            isDismissable: isDismissable
        )
        
        viewController.addDisposable(presenter)
        
        presenter.view = viewController
        
        return viewController
    }
}
