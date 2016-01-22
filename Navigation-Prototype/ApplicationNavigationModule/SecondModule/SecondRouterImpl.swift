import UIKit

final class SecondRouterImpl: BaseRouter {
    
}

extension  SecondRouterImpl: SecondRouter {
    func showNextSecondModule(sender sender: AnyObject, title: Int) {
        let navigationController = UINavigationController()
        let transitionsHandler = navigationController.wrappedInNavigationTransitionsHandler()
        
        let viewController = AssemblyFactory.secondModuleAssembly().module(
            parentRouter: self,
            transitionsHandler: transitionsHandler,
            title: String(title + 1)).0

        navigationController.viewControllers = [viewController]
        
        presentModalViewController(
            viewController,
            inNavigationController: navigationController,
            navigationTransitionsHandler: transitionsHandler)
    }
}