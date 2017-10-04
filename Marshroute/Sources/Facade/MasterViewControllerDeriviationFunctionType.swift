import UIKit

public typealias DeriveMasterViewController = ((MasterDetailRouterSeed) -> (UIViewController))

public enum MasterViewControllerDeriviationFunctionType {
    // Creates a `UIViewController`
    case controller(DeriveMasterViewController)
    
    // Creates a `UIViewController` wrapped in `UINavigationController`
    case controllerInNavigationController(DeriveMasterViewController)
}
