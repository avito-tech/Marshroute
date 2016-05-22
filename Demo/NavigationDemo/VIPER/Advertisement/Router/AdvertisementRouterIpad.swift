import UIKit
import AvitoNavigation

final class AdvertisementRouterIpad: BaseDemoRouter, AdvertisementRouter {
    // MARK: - AdvertisementRouter
    func showSimilarSearchResult(searchResultId searchResultId: SearchResultId) {
        pushViewControllerDerivedFrom { routerSeed -> UIViewController in
            let advertisementAssembly = assemblyFactory.advertisementAssembly()
            
            let viewController = advertisementAssembly.ipadModule(
                searchResultId: searchResultId,
                routerSeed: routerSeed
            )
            
            return viewController
        }
    }
    
    func showRecursion(sender: AnyObject) {
        guard let barButtonItem = sender as? UIBarButtonItem
            else { return }
        
        presentPopoverWithNavigationControllerFromBarButtonItem(barButtonItem) { (routerSeed) -> UIViewController in
            let recursionAssembly = assemblyFactory.recursionAssembly()
            
            let viewController = recursionAssembly.ipadModule(routerSeed: routerSeed)
            
            return viewController
        }
    }
}
