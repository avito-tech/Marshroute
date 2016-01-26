import UIKit

final class FirstRouterImpl: BaseRouter {}

extension FirstRouterImpl: FirstRouter {
    func showWhiteModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool) {
        let viewController = AssemblyFactory.firstModuleAssembly().iphoneModule(
            String(count + 1),
            parentRouter: self,
            transitionsHandler: transitionsHandler,
            canShowFirstModule: canShowFirstModule,
            canShowSecondModule: canShowSecondModule,
            dismissable: false,
            withTimer: false).0
        
        pushViewController(viewController)
    }
    
    func showRedModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool) {
        let viewController = AssemblyFactory.firstModuleAssembly().iphoneModule(
            String(count + 1),
            parentRouter: self,
            transitionsHandler: transitionsHandler,
            canShowFirstModule: canShowFirstModule,
            canShowSecondModule: canShowSecondModule,
            dismissable: false,
            withTimer: false).0
        
        pushViewController(viewController)
    }
    
    func showSecondModule(sender sender: AnyObject?) {
        func secondModuleForTransitionsHandler(transitionsHandler: TransitionsHandler) -> UIViewController {
            
            let viewController = AssemblyFactory.secondModuleAssembly()
                .iphoneModule(
                    parentRouter: self,
                    transitionsHandler: transitionsHandler,
                    title: "1",
                    withTimer: true,
                    canShowModule1: true).0
            return viewController
        }

        presentDerivedModalViewControllerFrom(deriviationClosure: secondModuleForTransitionsHandler)
    }
}