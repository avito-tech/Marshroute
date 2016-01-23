import UIKit

final class SecondRouterImpl: BaseRouter {
    
}

extension SecondRouterImpl: SecondRouter {
    func showFirstModule(sender sender: AnyObject) {
        func firstViewControllerForTransitionsHandler(transitionsHandler: TransitionsHandler) -> UIViewController {
            let viewController = AssemblyFactory.firstModuleAssembly()
                .iphoneModule(
                    "1",
                    parentRouter: self,
                    transitionsHandler: transitionsHandler,
                    canShowFirstModule: true,
                    canShowSecondModule: false,
                    dismissable: true).0
            return viewController
        }
        
        presentModalViewControllerDerivedFrom(closure: firstViewControllerForTransitionsHandler)
    }

    func dismissChildModules() {
        focusTransitionsHandlerBackOnMyRootViewController()
        //transitionsHandler?.undoAllTransitions()
    }
    
    func showSecondModule(sender sender: AnyObject, title: Int) {
        func secondViewControllerForTransitionsHandler(transitionsHandler: TransitionsHandler) -> UIViewController {
            let viewController = AssemblyFactory.secondModuleAssembly()
                .iphoneModule( // 2
                    parentRouter: self,
                    transitionsHandler: transitionsHandler,
                    title: String(title + 1),
                    withTimer: false,
                    canShowModule1: true).0
            return viewController
        }
        presentModalViewControllerDerivedFrom(closure: secondViewControllerForTransitionsHandler)
    }
}