import UIKit

final class SecondRouterImpl: BaseRouter {
    
}

extension SecondRouterImpl: SecondRouter {
    func showFirstModule(sender sender: AnyObject) {
        presentModalViewControllerDerivedFrom( { (transitionId, transitionsHandlerBox) -> UIViewController in
            let viewController = AssemblyFactory.firstModuleAssembly()
                .iphoneModule(
                    title: "1",
                    presentingTransitionsHandler: self.transitionsHandlerBox?.unbox(),
                    transitionId: transitionId,
                    transitionsHandlerBox: transitionsHandlerBox,
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
        presentModalViewControllerDerivedFrom( { (transitionId, transitionsHandlerBox) -> UIViewController in
            let viewController = AssemblyFactory.secondModuleAssembly()
                .iphoneModule( // 2
                    transitionsHandlerBox: transitionsHandlerBox,
                    title: String(title + 1),
                    withTimer: false,
                    canShowModule1: true,
                    transitionId: transitionId,
                    presentingTransitionsHandler: self.transitionsHandlerBox?.unbox(),
                    transitionsCoordinator: transitionsCoordinator,
                    transitionIdGenerator: transitionIdGenerator)
            
            return viewController
        })
    }
}