import UIKit

final class FirstRouterImpl_IpadDetail: BaseRouter {}

extension FirstRouterImpl_IpadDetail: FirstRouter {
    func showWhiteModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool) {
        let viewController = AssemblyFactory.firstModuleAssembly().ipadDetailModule(
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
        let viewController = AssemblyFactory.firstModuleAssembly().ipadDetailModule(
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
        guard let barButtonItem = sender as? UIBarButtonItem
            else { return }
        
        func secondModuleForTransitionsHandler(transitionsHandler: TransitionsHandler) -> UIViewController {
            let viewController = AssemblyFactory.secondModuleAssembly()
                .ipadModule(
                    parentRouter: self,
                    transitionsHandler: transitionsHandler,
                    title: "1",
                    withTimer: true,
                    canShowModule1: true).0
            return viewController
        }
        
        presentViewControllerDerivedFrom(
            closure: secondModuleForTransitionsHandler,
            inPopoverFromBarButtonItem: barButtonItem
        )
    }
    
    func dismissChildModules() {
        focusTransitionsHandlerBackOnMyRootViewController()
        //transitionsHandler?.undoAllTransitions()
    }
}