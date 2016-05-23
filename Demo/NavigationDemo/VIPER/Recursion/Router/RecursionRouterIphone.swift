import UIKit
import AvitoNavigation

final class RecursionRouterIphone: BaseDemoRouter, RecursionRouter {
    func showRecursion(sender: AnyObject) {
        presentModalNavigationControllerWithRootViewControllerDerivedFrom { routerSeed -> UIViewController in
            let recursionAssembly = assemblyFactory.recursionAssembly()
            
            let viewController = recursionAssembly.module(
                routerSeed: routerSeed
            )
            
            return viewController
        }
    }

    func showCategories(sender: AnyObject) {
        presentModalNavigationControllerWithRootViewControllerDerivedFrom( { routerSeed -> UIViewController in
            let categoriesAssembly = assemblyFactory.categoriesAssembly()
            
            let viewController = categoriesAssembly.module(routerSeed: routerSeed)
            
            return viewController
            }, animator: RecursionAnimator())
    }
}
