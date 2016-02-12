import UIKit

final class FirstRouterImpl: BaseRouter {}

extension FirstRouterImpl: FirstRouter {
    func showWhiteModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool) {
        pushViewControllerDerivedFrom { (routerSeed) -> UIViewController in
            let viewController = AssemblyFactory.firstModuleAssembly().iphoneModule(
                title: String(count + 1),
                canShowFirstModule: canShowFirstModule,
                canShowSecondModule: canShowSecondModule,
                dismissable: false,
                withTimer: false,
                routerSeed: routerSeed)
            return viewController
        }
    }
    
    func showRedModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool) {
        pushViewControllerDerivedFrom {(routerSeed) -> UIViewController in
            let viewController = AssemblyFactory.firstModuleAssembly().iphoneModule(
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
        presentModalViewControllerDerivedFrom { (routerSeed) -> UIViewController in
            let viewController = AssemblyFactory.secondModuleAssembly()
                .iphoneModule(
                    title: "1",
                    withTimer: true,
                    canShowModule1: true,
                    routerSeed: routerSeed)
            return viewController
        }
    }
    
    func showSecondModuleIfAuthorizationSucceeds() {
        let applicationModuleInput = AssemblyFactory.applicationModuleAssembly().sharedModuleInput()
        applicationModuleInput.showAuthorizationModule( { [weak self] (authed) -> Void in
            if (authed) {
                if let strongSelf = self {
                    strongSelf.presentModalViewControllerDerivedFrom { (routerSeed) -> UIViewController in
                        let viewController = AssemblyFactory.secondModuleAssembly()
                            .iphoneModule(
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
        focusOnCurrentModule()
    }
}