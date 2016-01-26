import UIKit

final class SecondRouterImpl: BaseRouter {
    
}

extension SecondRouterImpl: SecondRouter {
    func showFirstModule(sender sender: AnyObject) {
        presentModalViewControllerDerivedFrom( {[weak self] (transitionId, transitionsHandler) -> UIViewController in
            let viewController = AssemblyFactory.firstModuleAssembly()
                .iphoneModule(
                    "1",
                    parentTransitionsHandler: self?.transitionsHandler,
                    transitionId: transitionId,
                    transitionsHandler: transitionsHandler,
                    canShowFirstModule: true,
                    canShowSecondModule: false,
                    dismissable: true,
                    withTimer: true).0
            
            return viewController
        })
    }
    
    func showSecondModule(sender sender: AnyObject, title: Int) {
        presentModalViewControllerDerivedFrom( {[weak self] (transitionId, transitionsHandler) -> UIViewController in
            let viewController = AssemblyFactory.secondModuleAssembly()
                .iphoneModule( // 2
                    transitionsHandler,
                    title: String(title + 1),
                    withTimer: false,
                    canShowModule1: true,
                    transitionId: transitionId,
                    parentTransitionsHandler: self?.transitionsHandler).0

            return viewController
        })
    }
}