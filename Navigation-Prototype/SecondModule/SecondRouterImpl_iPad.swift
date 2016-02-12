import UIKit

final class SecondRouterImpl_iPad: BaseRouter {
    
}

extension  SecondRouterImpl_iPad: SecondRouter {
    func showFirstModule(sender sender: AnyObject) {
        guard let barButtonItem = sender as? UIBarButtonItem
            else { return }
        
        presentPopoverFromBarButtonItem(
            barButtonItem,
            withViewControllerDerivedFrom: { (routerSeed) -> UIViewController in
                
                let viewController = AssemblyFactory.firstModuleAssembly()
                    .ipadDetailModule( // 2
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
        guard let barButtonItem = sender as? UIBarButtonItem
            else { return }

        presentPopoverFromBarButtonItem(
            barButtonItem,
            withViewControllerDerivedFrom: { (routerSeed) -> UIViewController in
                let viewController = AssemblyFactory.secondModuleAssembly()
                    .ipadModule( // 2
                        title: String(title + 1),
                        withTimer: false,
                        canShowModule1: true,
                        routerSeed: routerSeed)
                
                return viewController
        })
    }
}