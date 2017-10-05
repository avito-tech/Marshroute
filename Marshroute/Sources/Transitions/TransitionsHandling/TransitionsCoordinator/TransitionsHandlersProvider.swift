import UIKit

public protocol TransitionsHandlersProvider: class {
    func animatingTransitionsHandler()
        -> AnimatingTransitionsHandler
    
    func navigationTransitionsHandler(navigationController: UINavigationController)
        -> NavigationTransitionsHandlerImpl
    
    func topTransitionsHandlerBox(transitionsHandlerBox: TransitionsHandlerBox)
        -> TransitionsHandlerBox
    
    // `splitViewController` is made `Optional` to allow `MarshrouteFacade` to create `RouterSeed`s 
    // before `UISplitViewController`-based modules (a module is usually created from a `RouterSeed`)
    func splitViewTransitionsHandler(splitViewController: UISplitViewController?)
        -> SplitViewTransitionsHandlerImpl
    
    // `tabBarController` is made `Optional` to allow `MarshrouteFacade` to create `RouterSeed`s 
    // before `UITabBarController`-based modules (a module is usually created from a `RouterSeed`)
    func tabBarTransitionsHandler(tabBarController: UITabBarController?)
        -> TabBarTransitionsHandlerImpl
}

public extension TransitionsHandlersProvider {
    func splitViewTransitionsHandler()
        -> SplitViewTransitionsHandlerImpl
    {
        return splitViewTransitionsHandler(splitViewController: nil)
    }
    
    func tabBarTransitionsHandler()
        -> TabBarTransitionsHandlerImpl
    {
        return tabBarTransitionsHandler(tabBarController: nil)
    }
}
