import UIKit

public protocol TransitionsHandlersProvider: AnyObject {
    func animatingTransitionsHandler()
        -> AnimatingTransitionsHandler
    
    func navigationTransitionsHandler(navigationController: UINavigationController)
        -> NavigationTransitionsHandler
    
    func topTransitionsHandlerBox(transitionsHandlerBox: TransitionsHandlerBox)
        -> TransitionsHandlerBox
    
    func splitViewTransitionsHandler(splitViewController: SplitViewControllerProtocol & UIViewController)
        -> SplitViewTransitionsHandler
    
    func tabBarTransitionsHandler(tabBarController: TabBarControllerProtocol & UIViewController)
        -> TabBarTransitionsHandler
}
