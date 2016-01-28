import Foundation
import UIKit

final class ApplicationNavigationAssemblyImpl: ApplicationNavigationAssembly  {
    
    func module(navigationRootsHolder: NavigationRootsHolder) -> (UIViewController, ApplicationNavigationModuleInput) {
        
        let interactor = ApplicationNavigationInteractorImpl()
        
        let presenter = ApplicationNavigationPresenter(
            interactor: interactor
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
        
        let router = ApplicationNavigationRouterImpl(
            transitionsHandler: tabTransitionsHandler,
            transitionId: nil,
            parentTransitionsHandler: nil
        )
        
        presenter.router = router

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
        
        firstTransitionHandler.resetWithTransition { (generatedTransitionId) -> ForwardTransitionContext in
            let firstViewController = AssemblyFactory.firstModuleAssembly().iphoneModule("1", parentTransitionsHandler: nil, transitionId: generatedTransitionId, transitionsHandler: firstTransitionHandler, canShowFirstModule: true, canShowSecondModule: false, dismissable: false, withTimer: true).0
            
            let resetContext = ForwardTransitionContext(
                resetingWithViewController: firstViewController,
                transitionsHandler: firstTransitionHandler,
                animator: NavigationTransitionsAnimator(),
                transitionId: generatedTransitionId)
            
            return resetContext
        }
        
        let secondNavigation = UINavigationController()
        let secondTransitionHandler = secondNavigation.wrappedInNavigationTransitionsHandler()
        
        secondTransitionHandler.resetWithTransition { (generatedTransitionId) -> ForwardTransitionContext in
            let secondViewController = AssemblyFactory.secondModuleAssembly().iphoneModule(secondTransitionHandler, title: "1", withTimer: true, canShowModule1: true, transitionId: generatedTransitionId, parentTransitionsHandler: nil).0
            
            let resetContext = ForwardTransitionContext(
                resetingWithViewController: secondViewController,
                transitionsHandler: secondTransitionHandler,
                animator: NavigationTransitionsAnimator(),
                transitionId: generatedTransitionId)
            
            return resetContext
        }

        firstNavigation.tabBarItem.title = "1"
        secondNavigation.tabBarItem.title = "2"
        
        let controllers = [firstNavigation, secondNavigation]
        return (controllers, [firstTransitionHandler, secondTransitionHandler])
    }
    
    private func createTabControllersIpad() -> ([UIViewController], [TransitionsHandler]) {
        let firstSplit = UISplitViewController()
        let firstSplitTransitionHandler = firstSplit.wrappedInSplitViewTransitionsHandler()
        do {
            let masterNavigation = UINavigationController()
            let detailNavigation = UINavigationController()
            
            firstSplit.viewControllers = [masterNavigation, detailNavigation]
            firstSplit.tabBarItem.title = "1"
            
            let masterTransitionsHandler = masterNavigation.wrappedInNavigationTransitionsHandler()
            let detailTransitionsHandler = detailNavigation.wrappedInNavigationTransitionsHandler()
            
            masterTransitionsHandler.resetWithTransition { (generatedTransitionId) -> ForwardTransitionContext in
                let masterViewController = AssemblyFactory.firstModuleAssembly().ipadMasterModule("1", parentTransitionsHandler: nil, transitionId: generatedTransitionId, transitionsHandler: masterTransitionsHandler, detailTransitionsHandler: detailTransitionsHandler, canShowFirstModule: true, canShowSecondModule: false, dismissable: false, withTimer: true).0
                
                let resetMasterContext = ForwardTransitionContext(
                    resetingWithViewController: masterViewController,
                    transitionsHandler: masterTransitionsHandler,
                    animator: NavigationTransitionsAnimator(),
                    transitionId: generatedTransitionId)
                
                return resetMasterContext
            }
            
            detailTransitionsHandler.resetWithTransition { (generatedTransitionId) -> ForwardTransitionContext in
                let detailViewController = UIViewController()
                
                let resetDetailContext = ForwardTransitionContext(
                    resetingWithViewController: detailViewController,
                    transitionsHandler: detailTransitionsHandler,
                    animator: NavigationTransitionsAnimator(),
                    transitionId: generatedTransitionId)
                
                return resetDetailContext
            }
            
            
            firstSplitTransitionHandler.masterTransitionsHandler = masterTransitionsHandler
            firstSplitTransitionHandler.detailTransitionsHandler = detailTransitionsHandler
        }
        
        let secondNavigation = UINavigationController()
        let secondTransitionHandler = secondNavigation.wrappedInNavigationTransitionsHandler()
        let second = AssemblyFactory.secondModuleAssembly().ipadModule(secondTransitionHandler, title: "1", withTimer: true, canShowModule1: true, transitionId: nil, parentTransitionsHandler: nil).0
        secondNavigation.viewControllers = [second]
        secondNavigation.tabBarItem.title = "2"
        
        let controllers = [firstSplit, secondNavigation]
        return (controllers, [firstSplitTransitionHandler, secondTransitionHandler])
    }
    
}