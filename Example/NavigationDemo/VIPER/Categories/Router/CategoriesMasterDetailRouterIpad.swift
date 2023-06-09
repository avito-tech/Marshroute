import UIKit
import Marshroute

final class CategoriesMasterDetailRouterIpad: BaseDemoMasterDetailRouter, CategoriesRouter {
    func showSubcategories(categoryId: CategoryId) {
        pushMasterViewControllerDerivedFrom { routerSeed -> UIViewController in
            let subcategoriesAssembly = assemblyFactory.subcategoriesAssembly()
            
            let viewController = subcategoriesAssembly.ipadMasterDetailModule(
                categoryId: categoryId,
                routerSeed: routerSeed
            )
            
            return viewController
        }
    }

    func showSearchResults(categoryId: CategoryId) {
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
            
            let (_, viewController) = shelfAssembly.module(
                style: .root,
                routerSeed: routerSeed
            )
            
            return viewController
        }
    }
}
