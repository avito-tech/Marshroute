import UIKit

public protocol TransitionsHandlersProvider: AnyObject {
    func animatingTransitionsHandler()
        -> AnimatingTransitionsHandler
    
    func navigationTransitionsHandler(navigationController: UINavigationController)
        -> NavigationTransitionsHandlerImpl
    
    func topTransitionsHandlerBox(transitionsHandlerBox: TransitionsHandlerBox)
        -> TransitionsHandlerBox
    
    func splitViewTransitionsHandler(splitViewController: UISplitViewController)
        -> SplitViewTransitionsHandlerImpl
    
    func tabBarTransitionsHandler(tabBarController: UITabBarController)
        -> TabBarTransitionsHandlerImpl
}
