import UIKit

final class SecondRouterImpl: BaseRouter {
    
}

extension SecondRouterImpl: SecondRouter {
    func showSecondModule(sender sender: AnyObject, title: Int) {
       // 1
       // 1
        
        let navigationController = UINavigationController()
        let transitionsHandler = navigationController.wrappedInNavigationTransitionsHandler()
        
        let viewController = AssemblyFactory.secondModuleAssembly()
            .iphoneModule( // 2
            parentRouter: self,
            transitionsHandler: transitionsHandler,
            title: String(title + 1),
            withTimer: false).0

        navigationController.viewControllers = [viewController]
        
        // 3

        presentModalViewController(
            viewController,
            inNavigationController: navigationController,
            navigationTransitionsHandler: transitionsHandler)
    }

    func dismissChildModules() {
        focusTransitionsHandlerBackOnMyRootViewController()
        //transitionsHandler?.undoAllTransitions()
    }
}