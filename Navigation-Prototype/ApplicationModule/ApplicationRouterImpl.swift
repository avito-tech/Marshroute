import UIKit

final class ApplicationRouterImpl: BaseRouter {
    
}

extension ApplicationRouterImpl: ApplicationRouter {
    func showAuthorization(output output: AuthorizationModuleOutput) {        
        presentModalViewControllerDerivedFrom({ (routerSeed) -> UIViewController in
            let module = AssemblyFactory.authModuleAssembly()
                .module(
                    moduleOutput: output,
                    routerSeed: routerSeed)
            
            return module.viewController
        }, animator: CustomAnimator1())
    }
}