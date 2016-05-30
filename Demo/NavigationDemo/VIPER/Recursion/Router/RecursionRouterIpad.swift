import UIKit
import AvitoNavigation

final class RecursionRouterIpad: BaseDemoRouter, RecursionRouter {
    func showRecursion(sender: AnyObject) {
        guard let barButtonItem = sender as? UIBarButtonItem
            else { return }
        
        presentPopoverWithNavigationControllerFromBarButtonItem(barButtonItem) { routerSeed -> UIViewController in
            let recursionAssembly = assemblyFactory.recursionAssembly()
            
            let viewController = recursionAssembly.ipadModule(
                routerSeed: routerSeed
            )
            
            return viewController
        }
    }

    func showCategories(sender: AnyObject) {
        guard let barButtonItem = sender as? UIBarButtonItem
            else { return }
        
        presentPopoverWithNavigationControllerFromBarButtonItem(barButtonItem) { routerSeed -> UIViewController in
            let categoriesAssembly = assemblyFactory.categoriesAssembly()
            
            let viewController = categoriesAssembly.ipadModule(routerSeed: routerSeed)
            
            return viewController
        }
    }
}
