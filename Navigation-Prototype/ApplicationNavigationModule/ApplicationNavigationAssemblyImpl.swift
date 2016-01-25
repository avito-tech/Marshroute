import Foundation
import UIKit

final class ApplicationNavigationAssemblyImpl: ApplicationNavigationAssembly  {
    
    func module(navigationRootsHolder: NavigationRootsHolder) -> (UIViewController, ApplicationNavigationModuleInput) {
        
        let interactor = ApplicationNavigationInteractorImpl()
        let router = ApplicationNavigationRouterImpl()
        
        let presenter = ApplicationNavigationPresenter(
            interactor: interactor,
            router: router
        )
        
        let tabBarController = ApplicationNavigationViewController(
            output: presenter
        )
        presenter.viewInput = tabBarController
        interactor.output = presenter
        
        let controllersAndHandlers = createTabControllers()
        tabBarController.viewControllers = controllersAndHandlers.0
        
        let tabTransitionsHandler = tabBarController.wrappedInTabBarTransitionsHandler()
        tabTransitionsHandler.tabTransitionHandlers = controllersAndHandlers.1

        router.transitionsHandler = tabTransitionsHandler
        router.parentRouter = nil
        router.setRootViewControllerIfNeeded(tabBarController)
        
        navigationRootsHolder.rootTransitionsHandler = tabTransitionsHandler
        
        return (tabBarController, presenter)
    }
    
    private func createTabControllers() ->  ([UIViewController], [TransitionsHandler]) {
        return (UIDevice.currentDevice().userInterfaceIdiom == .Pad)
            ? createTabControllersIpad()
            : createTabControllersIphone()
    }
    
    private func createTabControllersIphone() -> ([UIViewController], [TransitionsHandler]) {
        let firstNavigation = UINavigationController()
        let firstTransitionHandler = firstNavigation.wrappedInNavigationTransitionsHandler()
        
        let first = AssemblyFactory.firstModuleAssembly().iphoneModule("1", parentRouter: nil, transitionsHandler: firstTransitionHandler, canShowFirstModule: true, canShowSecondModule: false, dismissable: false, withTimer: true).0
        firstNavigation.viewControllers = [first]
        firstNavigation.tabBarItem.title = "1"
        
        let secondNavigation = UINavigationController()
        let secondTransitionHandler = secondNavigation.wrappedInNavigationTransitionsHandler()
        let second = AssemblyFactory.secondModuleAssembly().iphoneModule(parentRouter: nil, transitionsHandler: secondTransitionHandler, title: "1", withTimer: true, canShowModule1: true).0
        secondNavigation.viewControllers = [second]
        secondNavigation.tabBarItem.title = "2"
        
        let controllers = [firstNavigation, secondNavigation]
        return (controllers, [firstTransitionHandler, secondTransitionHandler])
    }
    
    private func createTabControllersIpad() -> ([UIViewController], [TransitionsHandler]) {
        let firstSplit = UISplitViewController()
        let firstSplitTransitionHandler = firstSplit.wrappedInSplitViewTransitionsHandler()
        do {
            let detail = UIViewController()
            let detailNavigation = UINavigationController()
            detailNavigation.viewControllers = [detail]
            let detailTransitionHandler = detailNavigation.wrappedInNavigationTransitionsHandler()
            
            
            let masterNavigation = UINavigationController()
            let masterTransitionHandler = masterNavigation.wrappedInNavigationTransitionsHandler()
            
            let master = AssemblyFactory.firstModuleAssembly().ipadMasterModule("1", parentRouter: nil, transitionsHandler: masterTransitionHandler, detailTransitionsHandler: detailTransitionHandler, canShowFirstModule: true, canShowSecondModule: false, dismissable: false, withTimer: true).0
            masterNavigation.viewControllers = [master]
            
            
            firstSplit.viewControllers = [masterNavigation, detailNavigation]
            firstSplit.tabBarItem.title = "1"
            
            firstSplitTransitionHandler.masterTransitionsHandler = masterTransitionHandler
            firstSplitTransitionHandler.detailTransitionsHandler = detailTransitionHandler
        }
        
        let secondNavigation = UINavigationController()
        let secondTransitionHandler = secondNavigation.wrappedInNavigationTransitionsHandler()
        let second = AssemblyFactory.secondModuleAssembly().ipadModule(parentRouter: nil, transitionsHandler: secondTransitionHandler, title: "1", withTimer: true, canShowModule1: true).0
        secondNavigation.viewControllers = [second]
        secondNavigation.tabBarItem.title = "2"
        
        
        let controllers = [firstSplit, secondNavigation]
        return (controllers, [firstSplitTransitionHandler, secondTransitionHandler])
    }
    
}