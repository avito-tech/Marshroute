import UIKit

protocol AuthorizationAssembly {
    func module(
        presentingTransitionsHandler presentingTransitionsHandler: TransitionsHandler?,
        transitionId: TransitionId,
        transitionsHandlerBox: RouterTransitionsHandlerBox,
        moduleOutput: AuthorizationModuleOutput,
        transitionsCoordinator: TransitionsCoordinator,
        transitionIdGenerator: TransitionIdGenerator)
        -> (viewController: UIViewController, moduleInput: AuthorizationModuleInput)
}
