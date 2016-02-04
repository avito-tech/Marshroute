import UIKit

final class SecondRouterImpl_iPad_PushSecondModule: BaseRouterImpl {
    
}

extension  SecondRouterImpl_iPad_PushSecondModule: SecondRouter {
    func showFirstModule(sender sender: AnyObject) {
        guard let barButtonItem = sender as? UIBarButtonItem
            else { return }
        
        presentPopoverFromBarButtonItem(
            barButtonItem,
            withViewControllerDerivedFrom: { (transitionId, transitionsHandler) -> UIViewController in
                
                let viewController = AssemblyFactory.firstModuleAssembly()
                    .ipadDetailModule( // 2
                        "1",
                        presentingTransitionsHandler: self.transitionsHandler,
                        transitionId: transitionId,
                        transitionsHandler: transitionsHandler,
                        canShowFirstModule: true,
                        canShowSecondModule: false,
                        dismissable: true,
                        withTimer: true,
                        transitionsCoordinator: transitionsCoordinator).0
                return viewController
        })
    }
    
    func showSecondModule(sender sender: AnyObject, title: Int) {
        pushViewControllerDerivedFrom { (transitionId, transitionsHandler) -> UIViewController in
                let viewController = AssemblyFactory.secondModuleAssembly()
                    .ipadModule( // 2
                        transitionsHandler,
                        title: String(title + 1),
                        withTimer: true,                        
                        canShowModule1: true,
                        transitionId: transitionId,
                        presentingTransitionsHandler: self.transitionsHandler,
                        transitionsCoordinator: transitionsCoordinator).0
                return viewController
        }
    }
}