import UIKit

final class FirstRouterImpl_iPadMaster: BaseMasterDetailRouter {}

extension FirstRouterImpl_iPadMaster: FirstRouter {
    func showWhiteModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool) {
        pushMasterViewControllerDerivedFrom( { (routerSeed) -> UIViewController in
            let viewController = AssemblyFactory.firstModuleAssembly().ipadMasterDetailModule(
                title: String(count + 1),
                canShowFirstModule: canShowFirstModule,
                canShowSecondModule: canShowSecondModule,
                dismissable: false,
                withTimer: false,
                routerSeed: routerSeed)
            return viewController
        }, animator: CustomAnimator2())
    }
    
    func showRedModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool) {        
        setDetailViewControllerDerivedFrom { (routerSeed) -> UIViewController in
            let viewController = AssemblyFactory.firstModuleAssembly().ipadModule(
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