import UIKit

final class FirstRouterImpl: BaseRouter {}

extension FirstRouterImpl: FirstRouter {
    func showWhiteModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool) {
        pushViewControllerDerivedFrom {[weak self] (transitionId, transitionsHandler) -> UIViewController in
            let viewController = AssemblyFactory.firstModuleAssembly().iphoneModule(
                String(count + 1),
                parentTransitionsHandler: self?.transitionsHandler,
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
        pushViewControllerDerivedFrom {[weak self] (transitionId, transitionsHandler) -> UIViewController in
            let viewController = AssemblyFactory.firstModuleAssembly().iphoneModule(
                String(count + 1),
                parentTransitionsHandler: self?.transitionsHandler,
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
        presentModalViewControllerDerivedFrom {[weak self] (transitionId, transitionsHandler) -> UIViewController in
            let viewController = AssemblyFactory.secondModuleAssembly()
                .iphoneModule(
                    transitionsHandler,
                    title: "1",
                    withTimer: true,
                    canShowModule1: true,
                    transitionId: transitionId,
                    parentTransitionsHandler: self?.transitionsHandler).0
            return viewController
        }
    }
}