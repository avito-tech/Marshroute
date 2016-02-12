import UIKit

final class FirstRouterImpl_iPad: BaseRouter {}

extension FirstRouterImpl_iPad: FirstRouter {
    func showWhiteModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool) {
        pushViewControllerDerivedFrom { (transitionId, transitionsHandlerBox) -> UIViewController in
            let viewController = AssemblyFactory.firstModuleAssembly().ipadDetailModule(
                title: String(count + 1),
                presentingTransitionsHandler: self.transitionsHandlerBox?.unbox(),
                transitionId: transitionId,
                transitionsHandlerBox: transitionsHandlerBox,
                canShowFirstModule: canShowFirstModule,
                canShowSecondModule: canShowSecondModule,
                dismissable: false,
                withTimer: false,
                transitionsCoordinator: transitionsCoordinator,
                transitionIdGenerator: transitionIdGenerator)
            return viewController
        }
    }
    
    func showRedModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool) {
        pushViewControllerDerivedFrom { (transitionId, transitionsHandlerBox) -> UIViewController in
            let viewController = AssemblyFactory.firstModuleAssembly().ipadDetailModule(
                title: String(count + 1),
                presentingTransitionsHandler: self.transitionsHandlerBox?.unbox(),
                transitionId: transitionId,
                transitionsHandlerBox: transitionsHandlerBox,
                canShowFirstModule: canShowFirstModule,
                canShowSecondModule: canShowSecondModule,
                dismissable: false,
                withTimer: false,
                transitionsCoordinator: transitionsCoordinator,
                transitionIdGenerator: transitionIdGenerator)
            return viewController
        }
    }
    
    func showSecondModule(sender sender: AnyObject?) {
        guard let barButtonItem = sender as? UIBarButtonItem
            else { return }
        
        presentPopoverFromBarButtonItem(
            barButtonItem,
            withViewControllerDerivedFrom: { (transitionId, transitionsHandlerBox) -> UIViewController in
                let viewController = AssemblyFactory.secondModuleAssembly()
                    .ipadModule(
                        transitionsHandlerBox: transitionsHandlerBox,
                        title: "1",
                        withTimer: true,
                        canShowModule1: true,
                        transitionId: transitionId,
                        presentingTransitionsHandler: self.transitionsHandlerBox?.unbox(),
                        transitionsCoordinator: transitionsCoordinator,
                        transitionIdGenerator: transitionIdGenerator)
                return viewController
        })
    }
    
    func showSecondModuleIfAuthorizationSucceeds() {
        let applicationModuleInput = AssemblyFactory.applicationModuleAssembly().sharedModuleInput()
        applicationModuleInput.showAuthorizationModule( { [weak self] (authed) -> Void in
            if (authed) {
                if let strongSelf = self {
                    strongSelf.presentModalViewControllerDerivedFrom( { (transitionId, transitionsHandlerBox) -> UIViewController in
                        let viewController = AssemblyFactory.secondModuleAssembly()
                            .ipadModule(
                                transitionsHandlerBox: transitionsHandlerBox,
                                title: "1",
                                withTimer: true,
                                canShowModule1: true,
                                transitionId: transitionId,
                                presentingTransitionsHandler: strongSelf.transitionsHandlerBox?.unbox(),
                                transitionsCoordinator: strongSelf.transitionsCoordinator,
                                transitionIdGenerator: strongSelf.transitionIdGenerator)
                        return viewController
                    }, animator: CustomAnimator1())
                }
            }
        })
    }
    
    func focusOnCurrentModuleAndResetDetail() {
        focusOnCurrentModule()
    }
}