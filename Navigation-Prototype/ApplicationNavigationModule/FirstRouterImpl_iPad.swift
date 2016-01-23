import UIKit

final class FirstRouterImpl_iPad: MasterRouter {}

extension FirstRouterImpl_iPad: FirstRouter {
    func showWhiteModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool) {
        let viewController = AssemblyFactory.firstModuleAssembly().ipadMasterModule(
            String(count + 1),
            parentRouter: self,
            transitionsHandler: transitionsHandler,
            detailTransitionsHandler: detailTransitionsHandler,
            canShowFirstModule: canShowFirstModule,
            canShowSecondModule: canShowSecondModule).0
        
        pushViewController(viewController)
    }
    
    func showRedModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool) {
        let viewController = AssemblyFactory.firstModuleAssembly().ipadDetailModule(
            String(count + 1),
            parentRouter: self,
            transitionsHandler: detailTransitionsHandler,
            canShowFirstModule: canShowFirstModule,
            canShowSecondModule: canShowSecondModule).0
        
        setDetailViewController(viewController)
    }
    
    func showSecondModule(sender sender: AnyObject?) {
        guard let barButtonItem = sender as? UIBarButtonItem
            else { return }
        
        let navigationController = UINavigationController()
        let transitionsHandler = navigationController.wrappedInNavigationTransitionsHandler()
        
        let viewController = AssemblyFactory.secondModuleAssembly()
            .ipadModule(
                parentRouter: self,
                transitionsHandler: transitionsHandler,
                title: "1",
                withTimer: true).0
        
        navigationController.viewControllers = [viewController];
        
        let popoverController = UIPopoverController(contentViewController: navigationController)
        
        presentViewController(
            viewController,
            inNavigationController: navigationController,
            inPopoverController: popoverController,
            fromBarButtonItem: barButtonItem)

    }
}