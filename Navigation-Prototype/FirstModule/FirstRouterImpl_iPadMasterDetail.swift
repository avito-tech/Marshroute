import UIKit

final class FirstRouterImpl_iPadMasterDetail: BaseMasterDetailRouterImpl {}

extension FirstRouterImpl_iPadMasterDetail: FirstRouter {
    func showWhiteModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool) {
        guard let detailTransitionsHandler = detailTransitionsHandler
            else { assert(false); return }
        
        pushViewControllerDerivedFrom( { (transitionId, transitionsHandler) -> UIViewController in
            let viewController = AssemblyFactory.firstModuleAssembly().ipadMasterModule(
                String(count + 1),
                presentingTransitionsHandler: self.transitionsHandler,
                transitionId: transitionId,
                transitionsHandler: transitionsHandler,
                detailTransitionsHandler: detailTransitionsHandler,
                canShowFirstModule: canShowFirstModule,
                canShowSecondModule: canShowSecondModule,
                dismissable: false,
                withTimer: false,
                transitionsCoordinator: transitionsCoordinator).0
            return viewController
        }, animator: CustomAnimator2())
    }
    
    func showRedModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool) {
        guard let detailTransitionsHandler = detailTransitionsHandler
            else { assert(false); return }
        
        setDetailViewControllerDerivedFrom { (transitionId, transitionsHandler) -> UIViewController in
            let viewController = AssemblyFactory.firstModuleAssembly().ipadDetailModule(
                String(count + 1),
                presentingTransitionsHandler: self.transitionsHandler,
                transitionId: transitionId,
                transitionsHandler: detailTransitionsHandler,
                canShowFirstModule: canShowFirstModule,
                canShowSecondModule: canShowSecondModule,
                dismissable: false,
                withTimer: false,
                transitionsCoordinator: transitionsCoordinator).0
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
                        presentingTransitionsHandler: self.transitionsHandler,
                        transitionsCoordinator: transitionsCoordinator).0
                return viewController
        })
    }
    
    func showSecondModuleIfAuthorizationSucceeds() {
        let applicationModuleInput = AssemblyFactory.applicationModuleAssembly().sharedModule().moduleInput
        applicationModuleInput.showAuthorizationModule( { [weak self] (authed) -> Void in
            if (authed) {
                if let strongSelf = self {
                    
                    strongSelf.presentModalViewControllerDerivedFrom { (transitionId, transitionsHandler) -> UIViewController in
                        let viewController = AssemblyFactory.secondModuleAssembly()
                            .ipadModule(
                                transitionsHandler,
                                title: "1",
                                withTimer: true,
                                canShowModule1: true,
                                transitionId: transitionId,
                                presentingTransitionsHandler: strongSelf.transitionsHandler,
                                transitionsCoordinator: strongSelf.transitionsCoordinator).0
                        return viewController
                    }
                }
            }
        })
    }
    
    func focusOnCurrentModuleAndResetDetail() {
        // master
        focusOnCurrentModule()
        
        // detail
        setDetailViewControllerDerivedFrom { (transitionId, transitionsHandler) -> UIViewController in
            let result = UIViewController()
            result.view.backgroundColor = .redColor()
            return result
        }
    }
}