import UIKit

public protocol TransitionsHandlersProvider: class {
    func animatingTransitionsHandler()
        -> AnimatingTransitionsHandler
    
    func navigationTransitionsHandler(navigationController navigationController: UINavigationController)
        -> NavigationTransitionsHandlerImpl
    
    func topTransitionsHandlerBox(transitionsHandlerBox transitionsHandlerBox: TransitionsHandlerBox)
        -> TransitionsHandlerBox
    
    func splitViewTransitionsHandler(splitViewController splitViewController: UISplitViewController)
        -> SplitViewTransitionsHandlerImpl
    
    func tabBarTransitionsHandler(tabBarController tabBarController: UITabBarController)
        ->TabBarTransitionsHandlerImpl
}