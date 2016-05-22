import UIKit
import AvitoNavigation

final class SearchResultsRouterIphone: BaseDemoRouter, SearchResultsRouter {
    // MARK: - SearchResultsRouter
    func showAdvertisement(searchResultId searchResultId: SearchResultId) {
        pushViewControllerDerivedFrom { routerSeed -> UIViewController in
            let advertisementAssembly = assemblyFactory.advertisementAssembly()
            
            let viewController = advertisementAssembly.module(
                searchResultId: searchResultId,
                routerSeed: routerSeed
            )
            
            return viewController
        }   
    }
    
    func showRecursion(sender: AnyObject) {
        presentModalNavigationControllerWithRootViewControllerDerivedFrom { (routerSeed) -> UIViewController in
            let recursionAssembly = assemblyFactory.recursionAssembly()
            
            let viewController = recursionAssembly.module(routerSeed: routerSeed)
            
            return viewController
        }
    }
}
