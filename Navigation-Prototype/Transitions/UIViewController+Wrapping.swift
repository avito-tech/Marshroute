import UIKit

// MARK: - кладем View Controller в соответствующий обработчик переходов
protocol ViewControllerInTransitionsHandlerWrapper: class {
    @warn_unused_result
    func wrapInNavigationTransitionsHandler(controller: UINavigationController) -> NavigationTransitionsHandler
    
    @warn_unused_result
    func wrapInSplitViewTransitionsHandler(controller: UISplitViewController) -> SplitViewTransitionsHandler
    
    @warn_unused_result
    func wrapInTabBarTransitionsHandler(controller: UITabBarController) -> TabBarTransitionsHandler
    
    @warn_unused_result
    func wrapInTransitionsHandler(controller: UIViewController) -> TransitionsHandler?
}

// MARK: простая реализация
final class ViewControllerInTransitionsHandlerWrapperImpl: ViewControllerInTransitionsHandlerWrapper {
    @warn_unused_result
    func wrapInNavigationTransitionsHandler(controller: UINavigationController) -> NavigationTransitionsHandler {
        return NavigationTransitionsHandler(navigationController: controller)
    }
    
    @warn_unused_result
    func wrapInSplitViewTransitionsHandler(controller: UISplitViewController) -> SplitViewTransitionsHandler {
        return SplitViewTransitionsHandler(splitViewController: controller)
    }
    
    @warn_unused_result
    func wrapInTabBarTransitionsHandler(controller: UITabBarController) -> TabBarTransitionsHandler {
        return TabBarTransitionsHandler(tabBarController: controller)
    }
    
    @warn_unused_result
    func wrapInTransitionsHandler(controller: UIViewController) -> TransitionsHandler? {
        var result: TransitionsHandler?
        
        if let navigationController = controller as? UINavigationController {
            result = wrapInNavigationTransitionsHandler(navigationController)
        }
        else if let tabBarController = controller as? UITabBarController {
            result = wrapInTabBarTransitionsHandler(tabBarController)
        }
        else if let splitViewController = controller as? UISplitViewController {
            result = wrapInSplitViewTransitionsHandler(splitViewController)
        }
        
        return result
    }
}

//MARK: - удобные расширения
extension UINavigationController {
    @warn_unused_result
    final func wrappedInNavigationTransitionsHandler(usingWrapper wrapper: ViewControllerInTransitionsHandlerWrapper = ViewControllerInTransitionsHandlerWrapperImpl()) -> NavigationTransitionsHandler {
        return wrapper.wrapInNavigationTransitionsHandler(self)
    }
    
    @warn_unused_result
    final func wrappedInPopoverController() -> UIPopoverController {
        return UIPopoverController(contentViewController: self)
    }
}

extension UISplitViewController {
    @warn_unused_result
    final func wrappedInSplitViewTransitionsHandler(usingWrapper wrapper: ViewControllerInTransitionsHandlerWrapper = ViewControllerInTransitionsHandlerWrapperImpl()) -> SplitViewTransitionsHandler {
        return wrapper.wrapInSplitViewTransitionsHandler(self)
    }
}

extension UITabBarController {
    @warn_unused_result
    final func wrappedInTabBarTransitionsHandler(usingWrapper wrapper: ViewControllerInTransitionsHandlerWrapper = ViewControllerInTransitionsHandlerWrapperImpl()) -> TabBarTransitionsHandler {
        return wrapper.wrapInTabBarTransitionsHandler(self)
    }
}

extension UIViewController {
    @warn_unused_result
    func wrappedInTransitionsHandler(usingWrapper wrapper: ViewControllerInTransitionsHandlerWrapper = ViewControllerInTransitionsHandlerWrapperImpl()) -> TransitionsHandler? {
        return wrapper.wrapInTransitionsHandler(self)
    }
}

// MARK: - кладем View Controller в Navigation Controller
protocol ViewControllerInNavigationControllerWrapper: class {
    @warn_unused_result
    func wrapInNavigationController(controller: UIViewController) -> UINavigationController
}

// MARK: простая реализация
final class ViewControllerInNavigationControllerWrapperImpl: ViewControllerInNavigationControllerWrapper {
    @warn_unused_result
    func wrapInNavigationController(controller: UIViewController) -> UINavigationController {
        if let navigationController = controller as? UINavigationController {
            return navigationController
        }
        return UINavigationController(rootViewController: controller)
    }
}

// MARK: - удобное расширение
extension UIViewController {
    @warn_unused_result
    func wrappedInNavigationController(usingWrapper wrapper: ViewControllerInNavigationControllerWrapper = ViewControllerInNavigationControllerWrapperImpl()) -> UINavigationController {
        return wrapper.wrapInNavigationController(self)
    }
}