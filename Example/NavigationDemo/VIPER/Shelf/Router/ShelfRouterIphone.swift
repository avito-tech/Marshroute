import UIKit
import Marshroute

final class ShelfRouterIphone: BaseDemoRouter, ShelfRouter {
    // MARK: - ShelfRouter
    func showShelf(
        style: ShelfStyle,
        configure: (ShelfModule) -> ())
    {
        let deriveViewController: (RouterSeed) -> (UIViewController) = { routerSeed in
            let (module, viewController) = self.assemblyFactory.shelfAssembly().module(
                style: style,
                routerSeed: routerSeed
            )
            
            configure(module)
            
            return viewController
        }
        
        switch style {
        case .root:
            assertionFailure()
        case .modalWithNavigationBar:
            presentModalNavigationControllerWithRootViewControllerDerivedFrom(deriveViewController)
        case .modalBottomSheetWithNavigationBar:
            let animator = BottomSheetModalNavigationAnimator(
                configuration: BottomSheetTransitionConfiguration(
                    allowStateChange: false //
                )
            )
            presentModalNavigationControllerWithRootViewControllerDerivedFrom(deriveViewController, animator: animator)
        case .modalBottomSheetWithoutNavigationBar:
            let animator = BottomSheetModalAnimator(
                configuration: BottomSheetTransitionConfiguration(
                    allowStateChange: false //
                )
            )
            presentModalViewControllerDerivedFrom(deriveViewController, animator: animator)
        }
    }
}
