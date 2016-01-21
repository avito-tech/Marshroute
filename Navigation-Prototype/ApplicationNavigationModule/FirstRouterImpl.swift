import Foundation

final class FirstRouterImpl: BaseRouter {}

extension FirstRouterImpl: FirstRouter {
    func gogogo(count: Int) {
        
        guard let transitionsHandler = transitionsHandler
            else { return }
        
        let targetTransitionsHandler = transitionsHandler
        
        let viewController = AssemblyFactory.firstModuleAssembly().module(String(count), parentRouter: self, transitionsHandler: targetTransitionsHandler).0
        viewController.title = String(count+1)
        
        let animator = NavigationTranstionsAnimator()
        
        let context = ForwardTransitionContext(pushingViewController: viewController, targetTransitionsHandler: targetTransitionsHandler, animator: animator)
        transitionsHandler.performTransition(context: context)
        
    }
}