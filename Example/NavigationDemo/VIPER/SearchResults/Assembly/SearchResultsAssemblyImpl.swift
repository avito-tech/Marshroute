import UIKit
import Marshroute

final class SearchResultsAssemblyImpl: BaseAssembly, SearchResultsAssembly {
    // MARK: - SearchResultsAssembly
    func module(categoryId categoryId: CategoryId, routerSeed: RouterSeed)
        -> UIViewController
    {
        let router = SearchResultsRouterIphone(
            assemblyFactory: assemblyFactory,
            routerSeed: routerSeed
        )
        
        return module(categoryId: categoryId, router: router)
    }
    
    func ipadModule(categoryId categoryId: CategoryId, routerSeed: RouterSeed)
        -> UIViewController
    {
        let router = SearchResultsRouterIpad(
            assemblyFactory: assemblyFactory,
            routerSeed: routerSeed
        )
        
        return module(categoryId: categoryId, router: router)
    }
    
    // MARK - Private
    private func module(categoryId categoryId: CategoryId, router: SearchResultsRouter)
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
        
        let viewController = SearchResultsViewController()
        viewController.addDisposable(presenter)
        
        presenter.view = viewController
        
        return viewController
    }
}
