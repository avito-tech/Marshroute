import UIKit

final class FirstRouterImpl_iPadMasterDetail: BaseMasterDetailRouter {}

extension FirstRouterImpl_iPadMasterDetail: FirstRouter {
    func showWhiteModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool) {
        guard let detailTransitionsHandlerBox = detailTransitionsHandlerBox
            else { assert(false); return }
        
        pushViewControllerDerivedFrom( { (transitionId, transitionsHandlerBox) -> UIViewController in
            let viewController = AssemblyFactory.firstModuleAssembly().ipadMasterModule(
                title: String(count + 1),
                presentingTransitionsHandler: self.transitionsHandlerBox?.unbox(),
                transitionId: transitionId,
                transitionsHandlerBox: transitionsHandlerBox,
                detailTransitionsHandlerBox: detailTransitionsHandlerBox,
                canShowFirstModule: canShowFirstModule,
                canShowSecondModule: canShowSecondModule,
                dismissable: false,
                withTimer: false,
                transitionsCoordinator: transitionsCoordinator,
                transitionIdGenerator: transitionIdGenerator)
            return viewController
        }, animator: CustomAnimator2())
    }
    
    func showRedModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool) {
        guard let detailTransitionsHandlerBox = detailTransitionsHandlerBox
            else { assert(false); return }
        
        setDetailViewControllerDerivedFrom { (transitionId, transitionsHandlerBox) -> UIViewController in
            let viewController = AssemblyFactory.firstModuleAssembly().ipadDetailModule(
                title: String(count + 1),
                presentingTransitionsHandler: nil,
                transitionId: transitionId,
                transitionsHandlerBox: detailTransitionsHandlerBox,
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
                    
                    strongSelf.presentModalViewControllerDerivedFrom { (transitionId, transitionsHandlerBox) -> UIViewController in
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
                    }
                }
            }
        })
    }
    
    func focusOnCurrentModuleAndResetDetail() {
        // master
        focusOnCurrentModule()
        
        // detail
        setDetailViewControllerDerivedFrom { (transitionId, transitionsHandlerBox) -> UIViewController in
            let result = UIViewController()
            result.view.backgroundColor = .redColor()
            return result
        }
    }
}