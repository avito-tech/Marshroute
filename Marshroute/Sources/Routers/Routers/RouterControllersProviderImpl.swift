import UIKit

public final class RouterControllersProviderImpl: RouterControllersProvider {
    public init() {}
    
    public func navigationController() -> UINavigationController {
        return UINavigationController()
    }
    
    public func splitViewController() -> SplitViewControllerProtocol & UIViewController {
        return UISplitViewController()
    }
    
    public func tabBarViewController() -> TabBarControllerProtocol & UIViewController {
        return UITabBarController()
    }
}
