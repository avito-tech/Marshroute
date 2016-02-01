import UIKit

final class FirstRouterImpl_IpadDetail: BaseRouter {}

extension FirstRouterImpl_IpadDetail: FirstRouter {
    func showWhiteModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool) {
        pushViewControllerDerivedFrom { (transitionId, transitionsHandler) -> UIViewController in
            let viewController = AssemblyFactory.firstModuleAssembly().ipadDetailModule(
                String(count + 1),
                presentingTransitionsHandler: self.transitionsHandler,
                transitionId: transitionId,
                transitionsHandler: transitionsHandler,
                canShowFirstModule: canShowFirstModule,
                canShowSecondModule: canShowSecondModule,
                dismissable: false,
                withTimer: false).0
            return viewController
        }
    }
    
    func showRedModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool) {        
        pushViewControllerDerivedFrom { (transitionId, transitionsHandler) -> UIViewController in
            let viewController = AssemblyFactory.firstModuleAssembly().ipadDetailModule(
                String(count + 1),
                presentingTransitionsHandler: self.transitionsHandler,
                transitionId: transitionId,
                transitionsHandler: transitionsHandler,
                canShowFirstModule: canShowFirstModule,
                canShowSecondModule: canShowSecondModule,
                dismissable: false,
                withTimer: false).0
            return viewController
        }
    }
    
    func showSecondModule(sender sender: AnyObject?) {
        guard let barButtonItem = sender as? UIBarButtonItem
            else { return }
        
        presentPopoverFromBarButtonItem(
            barButtonItem,
            withViewControllerDerivedFrom: { (transitionId, transitionsHandler) -> UIViewController in
                let viewController = AssemblyFactory.secondModuleAssembly()
                    .ipadModule(
                        transitionsHandler,
                        title: "1",
                        withTimer: true,
                        canShowModule1: true,
                        transitionId: transitionId,
                        presentingTransitionsHandler: self.transitionsHandler).0
                return viewController
        })
    }
    
    func showSecondModuleIfAuthorizationSucceeds() {
        AppDelegate.instance?.applicationModuleInput?.showAuthorizationModule( { [weak self] (authed) -> Void in
            if (authed) {
                self?.presentModalViewControllerDerivedFrom { (transitionId, transitionsHandler) -> UIViewController in
                    let viewController = AssemblyFactory.secondModuleAssembly()
                        .ipadModule(
                            transitionsHandler,
                            title: "1",
                            withTimer: true,
                            canShowModule1: true,
                            transitionId: transitionId,
                            presentingTransitionsHandler: self?.transitionsHandler).0
                    return viewController
                }
            }
            })
    }
}