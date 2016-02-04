import UIKit

protocol MasterRouter: class {
    func setMasterViewControllerDerivedFrom(
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    func setMasterViewControllerDerivedFrom(
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator)
}

// MARK: - MasterRouter Default Impl
extension MasterRouter where Self: MasterRouterTransitionable, Self: RouterIdentifiable {

    func setMasterViewControllerDerivedFrom(
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    {
        setMasterViewControllerDerivedFrom(
            closure, animator: NavigationTransitionsAnimator()
        )
    }

    func setMasterViewControllerDerivedFrom(
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator)
    {
        let viewController = closure(
            transitionId: transitionId,
            transitionsHandler: masterTransitionsHandler)
        
        let resetMasterContext = ForwardTransitionContext(
            resetingWithViewController: viewController,
            transitionsHandler: masterTransitionsHandler,
            animator: animator,
            transitionId: transitionId)
        
        masterTransitionsHandler.resetWithTransition(context: resetMasterContext)
    }
}