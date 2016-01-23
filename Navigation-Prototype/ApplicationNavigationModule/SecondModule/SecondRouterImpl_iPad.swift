import UIKit

final class SecondRouterImpl_iPad: BaseRouter {
    
}

extension  SecondRouterImpl_iPad: SecondRouter {
    func showSecondModule(sender sender: AnyObject, title: Int) {
        guard let barButtonItem = sender as? UIBarButtonItem
            else { return }
        
        let navigationController = UINavigationController()
        let transitionsHandler = navigationController.wrappedInNavigationTransitionsHandler()
        
        let viewController = AssemblyFactory.secondModuleAssembly()
            .ipadModule( // 2
            parentRouter: self,
            transitionsHandler: transitionsHandler,
            title: String(title + 1),
            withTimer: false).0

        navigationController.viewControllers = [viewController]
        
        let popoverController = UIPopoverController(contentViewController: navigationController)
        
        presentViewController(
            viewController,
            inNavigationController: navigationController,
            inPopoverController: popoverController,
            fromBarButtonItem: barButtonItem)
    }
    
    func dismissChildModules() {
        focusTransitionsHandlerBackOnMyRootViewController()        
        transitionsHandler?.undoAllTransitions()
    }
}