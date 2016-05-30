import UIKit
import AvitoNavigation

final class CategoriesRouterIpad: BaseDemoRouter, CategoriesRouter {
    // MARK: - CategoriesRouter
    func showSubcategories(categoryId categoryId: CategoryId) {
        pushViewControllerDerivedFrom { routerSeed -> UIViewController in
            let subcategoriesAssembly = assemblyFactory.subcategoriesAssembly()
            
            let viewController = subcategoriesAssembly.ipadModule(
                categoryId: categoryId,
                routerSeed: routerSeed
            )
            
            return viewController
        }
    }
    
    func showSearchResults(categoryId categoryId: CategoryId) {
        pushViewControllerDerivedFrom { routerSeed -> UIViewController in
            let searchResultsAssembly = assemblyFactory.searchResultsAssembly()
            
            let viewController = searchResultsAssembly.ipadModule(
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
