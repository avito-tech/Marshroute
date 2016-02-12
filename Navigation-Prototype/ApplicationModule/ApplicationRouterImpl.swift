import UIKit

final class ApplicationRouterImpl: BaseRouter {
    
}

extension ApplicationRouterImpl: ApplicationRouter {
    func showAuthorization(output output: AuthorizationModuleOutput) {        
        presentModalViewControllerDerivedFrom({ (transitionId, transitionsHandlerBox) -> UIViewController in
            let module = AssemblyFactory.authModuleAssembly()
                .module(
                    presentingTransitionsHandler: self.transitionsHandlerBox?.unbox(),
                    transitionId: transitionId,
                    transitionsHandlerBox: transitionsHandlerBox,
                    moduleOutput: output,
                    transitionsCoordinator: transitionsCoordinator,
                    transitionIdGenerator: transitionIdGenerator)
            return module.viewController
        }, animator: CustomAnimator1())
    }
}