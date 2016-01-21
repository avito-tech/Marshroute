import Foundation
import UIKit

private class NavigationRootsHolder {
    static var instance = NavigationRootsHolder()
    
    var rootTransitionsHandler: TransitionsHandler?
}

final class ApplicationNavigationModuleAssemblyImpl: ApplicationNavigationModuleAssembly {
    
    func module() -> (UIViewController, ApplicationNavigationModuleModuleInput) {
        
        let interactor = ApplicationNavigationModuleInteractorImpl()
        let router = ApplicationNavigationModuleRouterImpl()
        
        let presenter = ApplicationNavigationModulePresenter(
            interactor: interactor,
            router: router
        )
        
        let tabBarController = ApplicationNavigationModuleViewController(
            presenter: presenter
        )
        presenter.viewInput = tabBarController
        interactor.output = presenter
        
        let controllersAndHandlers = createTabControllers()
        tabBarController.viewControllers = controllersAndHandlers.0
        
        let tabTransitionsHandler = tabBarController.wrappedInTabBarTransitionsHandler()
        router.transitionsHandler = tabTransitionsHandler
        tabTransitionsHandler.tabTransitionHandlers = controllersAndHandlers.1
        NavigationRootsHolder.instance.rootTransitionsHandler = tabTransitionsHandler
        
        return (tabBarController, presenter)
    }
    
    private func createTabControllers() ->  ([UIViewController], [TransitionsHandler]) {
        return (UIDevice.currentDevice().userInterfaceIdiom == .Pad)
            ? createTabControllersIpad()
            : createTabControllersIphone()
    }
    
    private func createTabControllersIphone() -> ([UIViewController], [TransitionsHandler]) {
        let first = UIViewController()
        let firstNavigation = first.wrappedInNavigationController()
        firstNavigation.tabBarItem.title = "1"
        let firstTransitionHandler = firstNavigation.wrappedInNavigationTransitionsHandler()
        
        let second = UIViewController()
        let secondNavigation = second.wrappedInNavigationController()
        secondNavigation.tabBarItem.title = "2"
        let secondTransitionHandler = secondNavigation.wrappedInNavigationTransitionsHandler()
        
        let controllers = [firstNavigation, secondNavigation]
        return (controllers, [firstTransitionHandler, secondTransitionHandler])
    }
    
    private func createTabControllersIpad() -> ([UIViewController], [TransitionsHandler]) {
        let firstSplit = UISplitViewController()
        let firstSplitTransitionHandler = firstSplit.wrappedInSplitViewTransitionsHandler()
        do {
            let master = UIViewController()
            let detail = UIViewController()
            
            let masterNavigation = master.wrappedInNavigationController()
            let detailNavigation = detail.wrappedInNavigationController()
            
            firstSplit.viewControllers = [masterNavigation, detailNavigation]
            firstSplit.tabBarItem.title = "1"
            
            firstSplitTransitionHandler.masterTransitionsHandler = masterNavigation.wrappedInNavigationTransitionsHandler()
            firstSplitTransitionHandler.detailTransitionsHandler = detailNavigation.wrappedInNavigationTransitionsHandler()
        }
        
        let controllers = [firstSplit]
        let transitionHandlers = [firstSplitTransitionHandler]
        return (controllers, transitionHandlers)
    }
    
}