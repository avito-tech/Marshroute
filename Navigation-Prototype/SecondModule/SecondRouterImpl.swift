import UIKit

final class SecondRouterImpl: BaseRouterImpl {
    
}

extension SecondRouterImpl: SecondRouter {
    func showFirstModule(sender sender: AnyObject) {
        presentModalViewControllerDerivedFrom( { (transitionId, transitionsHandler) -> UIViewController in
            let viewController = AssemblyFactory.firstModuleAssembly()
                .iphoneModule(
                    "1",
                    presentingTransitionsHandler: self.transitionsHandler,
                    transitionId: transitionId,
                    transitionsHandler: transitionsHandler,
                    canShowFirstModule: true,
                    canShowSecondModule: false,
                    dismissable: true,
                    withTimer: true,
                    transitionsCoordinator: transitionsCoordinator,
                    transitionIdGenerator: transitionIdGenerator)
            
            return viewController
        })
    }
    
    func showSecondModule(sender sender: AnyObject, title: Int) {
        presentModalViewControllerDerivedFrom( { (transitionId, transitionsHandler) -> UIViewController in
            let viewController = AssemblyFactory.secondModuleAssembly()
                .iphoneModule( // 2
                    transitionsHandler,
                    title: String(title + 1),
                    withTimer: false,
                    canShowModule1: true,
                    transitionId: transitionId,
                    presentingTransitionsHandler: self.transitionsHandler,
                    transitionsCoordinator: transitionsCoordinator,
                    transitionIdGenerator: transitionIdGenerator)
            
            return viewController
        })
    }
}