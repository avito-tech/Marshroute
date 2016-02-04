import UIKit

final class ApplicationRouterImpl: BaseRouterImpl {
    
}

extension ApplicationRouterImpl: ApplicationRouter {
    func showAuthorization(output output: AuthorizationModuleOutput) {
        presentModalViewControllerDerivedFrom { (transitionId, transitionsHandler) -> UIViewController in
            let module = AssemblyFactory.authModuleAssembly()
                .module(
                    self.transitionsHandler,
                    transitionId: transitionId,
                    transitionsHandler: transitionsHandler,
                    moduleOutput: output,
                    transitionsCoordinator: transitionsCoordinator)
            return module.0
        }
    }
}