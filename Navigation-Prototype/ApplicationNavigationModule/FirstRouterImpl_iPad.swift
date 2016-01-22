import Foundation

final class FirstRouterImpl_iPad: BaseMasterRouter {
    private func gotoNextViewController(count: Int, moduleChangeable: Bool, changeModule: Bool) {
        guard let transitionsHandler = transitionsHandler
            else { return }
        
        guard let detailTransitionsHandler = detailTransitionsHandler
            else { return }
        
        let targetTransitionsHandler = changeModule ? detailTransitionsHandler : transitionsHandler
        
        let viewController = AssemblyFactory.firstModuleAssembly().module(String(count), parentRouter: self, transitionsHandler: targetTransitionsHandler, detailTransitionsHandler: detailTransitionsHandler, moduleChangeable: moduleChangeable).0
        viewController.title = String(count+1)
        
        let animator = NavigationTranstionsAnimator()
        
        let context = ForwardTransitionContext(pushingViewController: viewController, targetTransitionsHandler: targetTransitionsHandler, animator: animator)
        if changeModule {
            detailTransitionsHandler.undoAllTransitionsAndResetWithTransition(context)
        } else {
            transitionsHandler.performTransition(context: context)
        }
    }
}

extension FirstRouterImpl_iPad: FirstRouter {
    func gogogo(count: Int, moduleChangeable: Bool) {
        gotoNextViewController(count, moduleChangeable: moduleChangeable, changeModule: false)
    }
    
    func gogogo2(count: Int, moduleChangeable: Bool) {
        gotoNextViewController(count, moduleChangeable: moduleChangeable, changeModule: true)
    }
}