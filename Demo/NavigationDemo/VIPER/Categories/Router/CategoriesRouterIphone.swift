import UIKit
import AvitoNavigation

final class CategoriesRouterIphone: BaseDemoRouter, CategoriesRouter {
    // MARK: - CategoriesRouter
    func showSubCategories(categoryId categoryId: CategoryId) {
        pushViewControllerDerivedFrom { routerSeed -> UIViewController in
            let subCategoriesAssembly = assemblyFactory.subCategoriesAssembly()
            
            let viewController = subCategoriesAssembly.module(
                categoryId: categoryId,
                routerSeed: routerSeed
            )
            
            return viewController
        }
    }
    
    func showSearchResults(categoryId categoryId: CategoryId) {
        pushViewControllerDerivedFrom { routerSeed -> UIViewController in
            let searchResultsAssembly = assemblyFactory.searchResultsAssembly()
            
            let viewController = searchResultsAssembly.module(
                categoryId: categoryId,
                routerSeed: routerSeed
            )
            
            return viewController
        }
    }
    
    func returnToCategories() {
        focusOnCurrentModule()
    }
}
