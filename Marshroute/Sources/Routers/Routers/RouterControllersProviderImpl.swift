import UIKit

public final class RouterControllersProviderImpl: RouterControllersProvider {
    public init() {}
    
    public func navigationController() -> UINavigationController {
        return UINavigationController()
    }
    
    public func splitViewController() -> UISplitViewController {
        return UISplitViewController()
    }
    
    public func tabBarController() -> UITabBarController {
        return UITabBarController()
    }
}
