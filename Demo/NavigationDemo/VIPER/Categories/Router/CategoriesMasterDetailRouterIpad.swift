import UIKit
import AvitoNavigation

final class CategoriesMasterDetailRouterIpad: BaseDemoMasterDetailRouter, CategoriesRouter {
    func showSubcategories(categoryId categoryId: CategoryId) {
        pushMasterViewControllerDerivedFrom { routerSeed -> UIViewController in
            let subcategoriesAssembly = assemblyFactory.subcategoriesAssembly()
            
            let viewController = subcategoriesAssembly.ipadMasterDetailModule(
                categoryId: categoryId,
                routerSeed: routerSeed
            )
            
            return viewController
        }
    }

    func showSearchResults(categoryId categoryId: CategoryId) {
        setDetailViewControllerDerivedFrom { routerSeed -> UIViewController in
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
        
        setDetailViewControllerDerivedFrom { routerSeed -> UIViewController in
            let shelfAssembly = assemblyFactory.shelfAssembly()
            
            let viewController = shelfAssembly.module(routerSeed: routerSeed)
            
            return viewController
        }
    }
}
