import UIKit

final class SecondRouterImpl_iPad: BaseRouter {
    
}

extension  SecondRouterImpl_iPad: SecondRouter {
    func showFirstModule(sender sender: AnyObject) {
        guard let barButtonItem = sender as? UIBarButtonItem
            else { return }
        
        presentPopoverFromBarButtonItem(
            barButtonItem,
            withViewControllerDerivedFrom: { (transitionId, transitionsHandlerBox) -> UIViewController in
                
                let viewController = AssemblyFactory.firstModuleAssembly()
                    .ipadDetailModule( // 2
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
        guard let barButtonItem = sender as? UIBarButtonItem
            else { return }

        presentPopoverFromBarButtonItem(
            barButtonItem,
            withViewControllerDerivedFrom: { (transitionId, transitionsHandlerBox) -> UIViewController in
                let viewController = AssemblyFactory.secondModuleAssembly()
                    .ipadModule( // 2
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