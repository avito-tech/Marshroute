import UIKit

protocol AuthorizationAssembly {
    func module(
        presentingTransitionsHandler: TransitionsHandler?,
        transitionId: TransitionId,
        transitionsHandler: TransitionsHandler,
        moduleOutput: AuthorizationModuleOutput)
        -> (UIViewController, AuthorizationModuleInput)
}
