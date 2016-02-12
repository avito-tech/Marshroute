import UIKit

final class SecondRouterImpl: BaseRouter {
    
}

extension SecondRouterImpl: SecondRouter {
    func showFirstModule(sender sender: AnyObject) {
        presentModalViewControllerDerivedFrom( { (routerSeed) -> UIViewController in
            let viewController = AssemblyFactory.firstModuleAssembly()
                .iphoneModule(
                    title: "1",
                    canShowFirstModule: true,
                    canShowSecondModule: false,
                    dismissable: true,
                    withTimer: true,
                    routerSeed: routerSeed)
            
            return viewController
        })
    }
    
    func showSecondModule(sender sender: AnyObject, title: Int) {
        presentModalViewControllerDerivedFrom( { (routerSeed) -> UIViewController in
            let viewController = AssemblyFactory.secondModuleAssembly()
                .iphoneModule( // 2
                    title: String(title + 1),
                    withTimer: false,
                    canShowModule1: true,
                    routerSeed: routerSeed)
            
            return viewController
        })
    }
}