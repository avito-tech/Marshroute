import UIKit

final class FirstRouterImpl: BaseRouter {}

extension FirstRouterImpl: FirstRouter {
    func showWhiteModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool) {
        let viewController = AssemblyFactory.firstModuleAssembly().iphoneModule(
            String(count + 1),
            parentRouter: self,
            transitionsHandler: transitionsHandler,
            canShowFirstModule: canShowFirstModule,
            canShowSecondModule: canShowSecondModule).0
        
        pushViewController(viewController)
    }
    
    func showRedModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool) {
        let viewController = AssemblyFactory.firstModuleAssembly().iphoneModule(
            String(count + 1),
            parentRouter: self,
            transitionsHandler: transitionsHandler,
            canShowFirstModule: canShowFirstModule,
            canShowSecondModule: canShowSecondModule).0
        
        pushViewController(viewController)
    }
    
    func showSecondModule(sender sender: AnyObject?) {
        let navigationController = UINavigationController()
        let transitionsHandler = navigationController.wrappedInNavigationTransitionsHandler()
        
        let viewController = AssemblyFactory.secondModuleAssembly()
            .iphoneModule(
                parentRouter: self,
                transitionsHandler: transitionsHandler,
                title: "1",
                withTimer: true).0
        
        navigationController.viewControllers = [viewController]

        presentModalViewController(
            viewController,
            inNavigationController: navigationController,
            navigationTransitionsHandler: transitionsHandler)
    }
}