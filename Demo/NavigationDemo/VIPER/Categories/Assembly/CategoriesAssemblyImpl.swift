import UIKit
import AvitoNavigation

final class CategoriesAssemblyImpl: BaseAssembly, CategoriesAssembly, SubCategoriesAssembly {
    // MARK: - CategoriesAssembly
    func module(routerSeed routerSeed: RouterSeed)
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
    
    func ipadModule(routerSeed routerSeed: RouterSeed)
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
    
    func ipadMasterDetailModule(routerSeed routerSeed: MasterDetailRouterSeed)
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
    
    // MARK: - SubCategoriesAssembly
    func module(categoryId categoryId: CategoryId, routerSeed: RouterSeed)
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
    
    func ipadModule(categoryId categoryId: CategoryId, routerSeed: RouterSeed)
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

    func ipadMasterDetailModule(categoryId categoryId: CategoryId, routerSeed: MasterDetailRouterSeed)
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
    private func module(interactor interactor: CategoriesInteractor, router: CategoriesRouter, isDismissable: Bool)
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
