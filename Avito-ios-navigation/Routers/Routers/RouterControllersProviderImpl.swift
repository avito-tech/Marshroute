import UIKit

public final class RouterControllersProviderImpl: RouterControllersProvider {
    public func navigationController() -> UINavigationController {
        return UINavigationController()
    }
    public func splitViewController() -> UISplitViewController {
        return UISplitViewController()
    }
}