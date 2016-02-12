import UIKit

protocol AuthorizationAssembly {
    func module(
        moduleOutput moduleOutput: AuthorizationModuleOutput,
        routerSeed: BaseRouterSeed)
        -> (viewController: UIViewController, moduleInput: AuthorizationModuleInput)
}
