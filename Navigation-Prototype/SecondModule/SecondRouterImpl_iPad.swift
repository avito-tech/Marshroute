import UIKit

final class SecondRouterImpl_iPad: BaseRouter {
    
}

extension  SecondRouterImpl_iPad: SecondRouter {
    func showFirstModule(sender sender: AnyObject) {
        guard let barButtonItem = sender as? UIBarButtonItem
            else { return }

        func firstViewControllerForTransitionsHandler(transitionsHandler: TransitionsHandler) -> UIViewController {
            let viewController = AssemblyFactory.firstModuleAssembly()
                .ipadDetailModule( // 2
                    "1",
                    parentRouter: self,
                    transitionsHandler: transitionsHandler,
                    canShowFirstModule: true,
                    canShowSecondModule: false,
                    dismissable: true,
                    withTimer: true).0
            return viewController
        }

        presentDerivedViewControllerFrom(
            deriviationClosure: firstViewControllerForTransitionsHandler,
            inPopoverFromBarButtonItem: barButtonItem
        )
    }
    
    func showSecondModule(sender sender: AnyObject, title: Int) {
        guard let barButtonItem = sender as? UIBarButtonItem
            else { return }
        
        func secondModuleForTransitionsHandler(transitionsHandler: TransitionsHandler) -> UIViewController {
            let viewController = AssemblyFactory.secondModuleAssembly()
                .ipadModule( // 2
                    parentRouter: self,
                    transitionsHandler: transitionsHandler,
                    title: String(title + 1),
                    withTimer: false,
                    canShowModule1: true).0
            return viewController
        }
        
        presentDerivedViewControllerFrom(
            deriviationClosure: secondModuleForTransitionsHandler,
            inPopoverFromBarButtonItem: barButtonItem
        )
    }
}