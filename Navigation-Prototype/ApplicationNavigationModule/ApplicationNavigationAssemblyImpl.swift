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
        
        let sharedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let controllersAndHandlers = createTabControllers(sharedTransitionId: sharedTransitionId)
        tabBarController.viewControllers = controllersAndHandlers.0
        
        let tabTransitionsHandler = tabBarController.wrappedInTabBarTransitionsHandler()
        tabTransitionsHandler.tabTransitionHandlers = controllersAndHandlers.1
        
        let router = ApplicationNavigationRouterImpl(
            transitionsHandler: tabTransitionsHandler,
            transitionId: sharedTransitionId,
            presentedTransitionsHandler: nil
        )
        
        presenter.router = router

        navigationRootsHolder.rootTransitionsHandler = tabTransitionsHandler
        
        return (tabBarController, presenter)
    }
    
    private func createTabControllers(sharedTransitionId sharedTransitionId: TransitionId)
        ->  ([UIViewController], [TransitionsHandler])
    {
        return (UIDevice.currentDevice().userInterfaceIdiom == .Pad)
            ? createTabControllersIpad(sharedTransitionId: sharedTransitionId)
            : createTabControllersIphone(sharedTransitionId: sharedTransitionId)
    }
    
    private func createTabControllersIphone(sharedTransitionId sharedTransitionId: TransitionId)
        -> ([UIViewController], [TransitionsHandler])
    {
        let firstNavigation = UINavigationController()
        let firstTransitionHandler = firstNavigation.wrappedInNavigationTransitionsHandler()
        
        do {
            let firstViewController = AssemblyFactory.firstModuleAssembly().iphoneModule("1", presentedTransitionsHandler: nil, transitionId: sharedTransitionId, transitionsHandler: firstTransitionHandler, canShowFirstModule: true, canShowSecondModule: false, dismissable: false, withTimer: true).0
            
            let resetContext = ForwardTransitionContext(
                resetingWithViewController: firstViewController,
                transitionsHandler: firstTransitionHandler,
                animator: NavigationTransitionsAnimator(),
                transitionId: sharedTransitionId)
            
            firstTransitionHandler.resetWithTransition(context: resetContext)
        }
        
        let secondNavigation = UINavigationController()
        let secondTransitionHandler = secondNavigation.wrappedInNavigationTransitionsHandler()
        do {
            let secondViewController = AssemblyFactory.secondModuleAssembly().iphoneModule(secondTransitionHandler, title: "1", withTimer: true, canShowModule1: true, transitionId: sharedTransitionId, presentedTransitionsHandler: nil).0
            
            let resetContext = ForwardTransitionContext(
                resetingWithViewController: secondViewController,
                transitionsHandler: secondTransitionHandler,
                animator: NavigationTransitionsAnimator(),
                transitionId: sharedTransitionId)
            
            secondTransitionHandler.resetWithTransition(context: resetContext)
        }

        firstNavigation.tabBarItem.title = "1"
        secondNavigation.tabBarItem.title = "2"
        
        let controllers = [firstNavigation, secondNavigation]
        return (controllers, [firstTransitionHandler, secondTransitionHandler])
    }
    
    private func createTabControllersIpad(sharedTransitionId sharedTransitionId: TransitionId) -> ([UIViewController], [TransitionsHandler]) {
        let firstSplit = UISplitViewController()
        let firstSplitTransitionHandler = firstSplit.wrappedInSplitViewTransitionsHandler()
        do {
            let sharedFirstTransitionId = transitionIdGenerator.generateNewTransitionId()
            
            let masterNavigation = UINavigationController()
            let detailNavigation = UINavigationController()
            
            firstSplit.viewControllers = [masterNavigation, detailNavigation]
            firstSplit.tabBarItem.title = "1"
            
            let masterTransitionsHandler = masterNavigation.wrappedInNavigationTransitionsHandler()
            let detailTransitionsHandler = detailNavigation.wrappedInNavigationTransitionsHandler()
            
            do {
                let masterViewController = AssemblyFactory.firstModuleAssembly().ipadMasterModule("1", presentedTransitionsHandler: nil, transitionId: sharedFirstTransitionId, transitionsHandler: masterTransitionsHandler, detailTransitionsHandler: detailTransitionsHandler, canShowFirstModule: true, canShowSecondModule: false, dismissable: false, withTimer: true).0
                
                let resetMasterContext = ForwardTransitionContext(
                    resetingWithViewController: masterViewController,
                    transitionsHandler: masterTransitionsHandler,
                    animator: NavigationTransitionsAnimator(),
                    transitionId: sharedFirstTransitionId)
                
                masterTransitionsHandler.resetWithTransition(context: resetMasterContext)
            }
            
            do {
                let detailViewController = UIViewController()

                let resetDetailContext = ForwardTransitionContext(
                    resetingWithViewController: detailViewController,
                    transitionsHandler: detailTransitionsHandler,
                    animator: NavigationTransitionsAnimator(),
                    transitionId: sharedFirstTransitionId)
                
                detailTransitionsHandler.resetWithTransition(context: resetDetailContext)
            }
            
            firstSplitTransitionHandler.masterTransitionsHandler = masterTransitionsHandler
            firstSplitTransitionHandler.detailTransitionsHandler = detailTransitionsHandler
        }
        
        let secondNavigation = UINavigationController()
        let secondTransitionHandler = secondNavigation.wrappedInNavigationTransitionsHandler()
        let second = AssemblyFactory.secondModuleAssembly().ipadModule(secondTransitionHandler, title: "1", withTimer: true, canShowModule1: true, transitionId: sharedTransitionId, presentedTransitionsHandler: nil).0
        secondNavigation.viewControllers = [second]
        secondNavigation.tabBarItem.title = "2"
        
        let controllers = [firstSplit, secondNavigation]
        return (controllers, [firstSplitTransitionHandler, secondTransitionHandler])
    }
}

// MARK: - TransitionsGeneratorStorer
extension ApplicationNavigationAssemblyImpl: TransitionsGeneratorStorer {}