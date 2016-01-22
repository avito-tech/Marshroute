import Foundation

final class FirstRouterImpl: BaseRouter {
    private func gotoNextViewController(count: Int, moduleChangeable: Bool) {
        guard let transitionsHandler = transitionsHandler
            else { return }
        
        let targetTransitionsHandler = transitionsHandler
        
        let viewController = AssemblyFactory.firstModuleAssembly().module(String(count), parentRouter: self, transitionsHandler: targetTransitionsHandler, moduleChangeable: moduleChangeable).0
        viewController.title = String(count+1)
        
        let animator = NavigationTranstionsAnimator()
        
        let context = ForwardTransitionContext(pushingViewController: viewController, targetTransitionsHandler: targetTransitionsHandler, animator: animator)
        transitionsHandler.performTransition(context: context)
    }
}

extension FirstRouterImpl: FirstRouter {
    func gogogo(count: Int, moduleChangeable: Bool) {
        gotoNextViewController(count, moduleChangeable: moduleChangeable)
    }
    
    func gogogo2(count: Int, moduleChangeable: Bool) {
        gotoNextViewController(count, moduleChangeable: moduleChangeable)
    }
}