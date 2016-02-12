import UIKit

final class FirstRouterImpl: BaseRouter {}

extension FirstRouterImpl: FirstRouter {
    func showWhiteModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool) {
        pushViewControllerDerivedFrom { (transitionId, transitionsHandlerBox) -> UIViewController in
            let viewController = AssemblyFactory.firstModuleAssembly().iphoneModule(
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
        pushViewControllerDerivedFrom {(transitionId, transitionsHandlerBox) -> UIViewController in
            let viewController = AssemblyFactory.firstModuleAssembly().iphoneModule(
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
        presentModalViewControllerDerivedFrom { (transitionId, transitionsHandlerBox) -> UIViewController in
            let viewController = AssemblyFactory.secondModuleAssembly()
                .iphoneModule(
                    transitionsHandlerBox: transitionsHandlerBox,
                    title: "1",
                    withTimer: true,
                    canShowModule1: true,
                    transitionId: transitionId,
                    presentingTransitionsHandler: self.transitionsHandlerBox?.unbox(),
                    transitionsCoordinator: transitionsCoordinator,
                    transitionIdGenerator: transitionIdGenerator)
            return viewController
        }
    }
    
    func showSecondModuleIfAuthorizationSucceeds() {
        let applicationModuleInput = AssemblyFactory.applicationModuleAssembly().sharedModuleInput()
        applicationModuleInput.showAuthorizationModule( { [weak self] (authed) -> Void in
            if (authed) {
                if let strongSelf = self {
                    strongSelf.presentModalViewControllerDerivedFrom { (transitionId, transitionsHandlerBox) -> UIViewController in
                        let viewController = AssemblyFactory.secondModuleAssembly()
                            .iphoneModule(
                                transitionsHandlerBox: transitionsHandlerBox,
                                title: "1",
                                withTimer: true,
                                canShowModule1: true,
                                transitionId: transitionId,
                                presentingTransitionsHandler: strongSelf.transitionsHandlerBox?.unbox(),
                                transitionsCoordinator: strongSelf.transitionsCoordinator,
                                transitionIdGenerator: strongSelf.transitionIdGenerator)
                        return viewController
                    }
                }
            }
        })
    }
    
    func focusOnCurrentModuleAndResetDetail() {
        focusOnCurrentModule()
    }
}