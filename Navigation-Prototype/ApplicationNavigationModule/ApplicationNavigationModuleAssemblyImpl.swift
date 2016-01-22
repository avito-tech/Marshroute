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
        let firstNavigation = UINavigationController()
        let firstTransitionHandler = firstNavigation.wrappedInNavigationTransitionsHandler()

        let first = AssemblyFactory.firstModuleAssembly().module("1", parentRouter: nil, transitionsHandler: firstTransitionHandler, moduleChangeable: true).0
        firstNavigation.viewControllers = [first]
        firstNavigation.tabBarItem.title = "1"
        
        let secondNavigation = UINavigationController()
        let secondTransitionHandler = secondNavigation.wrappedInNavigationTransitionsHandler()
        let second = AssemblyFactory.secondModuleAssembly().iphoneModule(parentRouter: nil, transitionsHandler: secondTransitionHandler, title: "1").0
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
            
            let master = AssemblyFactory.firstModuleAssembly().module("1", parentRouter: nil, transitionsHandler: masterTransitionHandler, detailTransitionsHandler: detailTransitionHandler, moduleChangeable: true).0
            masterNavigation.viewControllers = [master]
            
            
            firstSplit.viewControllers = [masterNavigation, detailNavigation]
            firstSplit.tabBarItem.title = "1"
            
            firstSplitTransitionHandler.masterTransitionsHandler = masterTransitionHandler
            firstSplitTransitionHandler.detailTransitionsHandler = detailTransitionHandler
        }
        
        let secondNavigation = UINavigationController()
        let secondTransitionHandler = secondNavigation.wrappedInNavigationTransitionsHandler()
        let second = AssemblyFactory.secondModuleAssembly().ipadModule(parentRouter: nil, transitionsHandler: secondTransitionHandler, title: "1").0
        secondNavigation.viewControllers = [second]
        secondNavigation.tabBarItem.title = "2"
        
        
        let controllers = [firstSplit, secondNavigation]
        return (controllers, [firstSplitTransitionHandler, secondTransitionHandler])
    }
    
}