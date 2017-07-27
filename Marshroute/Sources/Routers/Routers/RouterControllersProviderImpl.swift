import UIKit

public final class RouterControllersProviderImpl: RouterControllersProvider 
{
    // MARK: - Init
    public init() {}
    
    // MARK: - RouterControllersProvider
    public func navigationController() -> UINavigationController {
        return UINavigationController()
    }
    
    public func splitViewController() -> UISplitViewController {
        return UISplitViewController()
    }
}
