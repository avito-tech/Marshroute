import UIKit

final class FirstRouterImpl_iPadMaster: MasterDetailRouter {}

extension FirstRouterImpl_iPadMaster: FirstRouter {
    func showWhiteModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool) {
        let detailTransitionsHandler = self.detailTransitionsHandler
        
        pushViewControllerDerivedFrom {[weak self] (transitionId, transitionsHandler) -> UIViewController in
            let viewController = AssemblyFactory.firstModuleAssembly().ipadMasterModule(
                String(count + 1),
                parentTransitionsHandler: self?.transitionsHandler,
                transitionId: transitionId,
                transitionsHandler: transitionsHandler,
                detailTransitionsHandler: detailTransitionsHandler,
                canShowFirstModule: canShowFirstModule,
                canShowSecondModule: canShowSecondModule,
                dismissable: false,
                withTimer: false).0
            return viewController
        }
    }
    
    func showRedModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool) {
        let detailTransitionsHandler = self.detailTransitionsHandler
        
        setDetailViewControllerDerivedFrom {[weak self] (transitionId, transitionsHandler) -> UIViewController in
            let viewController = AssemblyFactory.firstModuleAssembly().ipadDetailModule(
                String(count + 1),
                parentTransitionsHandler: self?.transitionsHandler,
                transitionId: transitionId,
                transitionsHandler: detailTransitionsHandler,
                canShowFirstModule: canShowFirstModule,
                canShowSecondModule: canShowSecondModule,
                dismissable: false,
                withTimer: false).0
            return viewController
        }
    }
    
    func showSecondModule(sender sender: AnyObject?) {
        guard let barButtonItem = sender as? UIBarButtonItem
            else { return }
        
        presentPopoverFromBarButtonItem(
            barButtonItem,
            withViewControllerDerivedFrom: {[weak self] (transitionId, transitionsHandler) -> UIViewController in
                let viewController = AssemblyFactory.secondModuleAssembly()
                    .ipadModule(
                        transitionsHandler,
                        title: "1",
                        withTimer: true,
                        canShowModule1: true,
                        transitionId: transitionId,
                        parentTransitionsHandler: self?.transitionsHandler).0
                return viewController
            })
    }
}