import UIKit
import Marshroute

final class SearchResultsAssemblyImpl: BaseAssembly, SearchResultsAssembly {
    // MARK: - SearchResultsAssembly
    func module(categoryId: CategoryId, routerSeed: RouterSeed)
        -> UIViewController
    {
        let router = SearchResultsRouterIphone(
            assemblyFactory: assemblyFactory,
            routerSeed: routerSeed
        )
        
        return module(categoryId: categoryId, router: router)
    }
    
    func ipadModule(categoryId: CategoryId, routerSeed: RouterSeed)
        -> UIViewController
    {
        let router = SearchResultsRouterIpad(
            assemblyFactory: assemblyFactory,
            routerSeed: routerSeed
        )
        
        return module(categoryId: categoryId, router: router)
    }
    
    // MARK - Private
    fileprivate func module(categoryId: CategoryId, router: SearchResultsRouter)
        -> UIViewController
    {
        let interactor = SearchResultsInteractorImpl(
            categoryId: categoryId,
            categoriesProvider: serviceFactory.categoriesProvider(),
            searchResultsProvider: serviceFactory.searchResultsProvider()
        )
        
        let presenter = SearchResultsPresenter(
            interactor: interactor,
            router: router
        )
        
        presenter.applicationModuleInput = assemblyFactory.applicationAssembly().sharedModuleInput()
        
        let viewController = SearchResultsViewController(
            peekAndPopUtility: marshrouteStack.peekAndPopUtility
        )
        
        viewController.addDisposable(presenter)
        
        presenter.view = viewController
        
        return viewController
    }
}
