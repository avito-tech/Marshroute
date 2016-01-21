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
        
        
        tabBarController.viewControllers = createTabControllers()
        
        let transitionsHandler = tabBarController.wrappedInTabBarTransitionsHandler()
        router.transitionsHandler = transitionsHandler
        NavigationRootsHolder.instance.rootTransitionsHandler = transitionsHandler
        
        return (tabBarController, presenter)
    }
    
    private func createTabControllers() -> [UIViewController] {
        return (UIDevice.currentDevice().userInterfaceIdiom == .Pad)
            ? createTabControllersIphad()
            : createTabControllersIphone()
    }
    
    private func createTabControllersIphone() -> [UIViewController] {
        let first = UIViewController()
        first.tabBarItem.title = "1"
        
        return [first]
    }
    
    private func createTabControllersIphad() -> [UIViewController] {
        let first = UISplitViewController()
        
        let master = UIViewController()
        let detail = UIViewController()
        
        let masterNavigation = master.wrappedInNavigationController()
        let detailNavigation = detail.wrappedInNavigationController()
        
        first.viewControllers = [masterNavigation, detailNavigation]
        first.tabBarItem.title = "1"
        
        return [first]
    }
    
}