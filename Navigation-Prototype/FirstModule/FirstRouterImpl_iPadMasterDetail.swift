import UIKit

final class FirstRouterImpl_iPadMasterDetail: BaseMasterDetailRouter {}

extension FirstRouterImpl_iPadMasterDetail: FirstRouter {
    func showWhiteModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool) {
        guard let detailTransitionsHandlerBox = detailTransitionsHandlerBox
            else { assert(false); return }
        
        pushViewControllerDerivedFrom( { (routerSeed) -> UIViewController in
            let viewController = AssemblyFactory.firstModuleAssembly().ipadMasterModule(
                title: String(count + 1),
                canShowFirstModule: canShowFirstModule,
                canShowSecondModule: canShowSecondModule,
                dismissable: false,
                withTimer: false,
                routerSeed: routerSeed,
                detailTransitionsHandlerBox: detailTransitionsHandlerBox)
            return viewController
        }, animator: CustomAnimator2())
    }
    
    func showRedModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool) {        
        setDetailViewControllerDerivedFrom { (routerSeed) -> UIViewController in
            let viewController = AssemblyFactory.firstModuleAssembly().ipadDetailModule(
                title: String(count + 1),
                canShowFirstModule: canShowFirstModule,
                canShowSecondModule: canShowSecondModule,
                dismissable: false,
                withTimer: false,
                routerSeed: routerSeed)
            return viewController
        }
    }
    
    func showSecondModule(sender sender: AnyObject?) {
        guard let barButtonItem = sender as? UIBarButtonItem
            else { return }
        
        presentPopoverFromBarButtonItem(
            barButtonItem,
            withViewControllerDerivedFrom: { (routerSeed) -> UIViewController in
                let viewController = AssemblyFactory.secondModuleAssembly()
                    .ipadModule(
                        title: "1",
                        withTimer: true,
                        canShowModule1: true,
                        routerSeed: routerSeed)
                return viewController
        })
    }
    
    func showSecondModuleIfAuthorizationSucceeds() {
        let applicationModuleInput = AssemblyFactory.applicationModuleAssembly().sharedModuleInput()
        applicationModuleInput.showAuthorizationModule( { [weak self] (authed) -> Void in
            if (authed) {
                if let strongSelf = self {
                    strongSelf.presentModalViewControllerDerivedFrom { (routerSeed) -> UIViewController in
                        let viewController = AssemblyFactory.secondModuleAssembly()
                            .ipadModule(
                                title: "1",
                                withTimer: true,
                                canShowModule1: true,
                                routerSeed: routerSeed)
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
        setDetailViewControllerDerivedFrom { (routerSeed) -> UIViewController in
            let result = UIViewController()
            result.view.backgroundColor = .redColor()
            return result
        }
    }
}