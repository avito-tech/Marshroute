import UIKit

final class ApplicationRouterImpl: BaseRouter {
    
}

extension ApplicationRouterImpl: ApplicationRouter {
    func showAuthorization(output output: AuthorizationModuleOutput) {
        presentModalViewControllerDerivedFrom { (transitionId, transitionsHandler) -> UIViewController in
            let module = AssemblyFactory.authModuleAssembly()
                .module(
                    self.transitionsHandler,
                    transitionId: transitionId,
                    transitionsHandler: transitionsHandler,
                    moduleOutput: output)
            return module.0
        }
    }
}