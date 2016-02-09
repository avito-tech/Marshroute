import UIKit

protocol MasterRouter: class {
    func setMasterViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
   
    func setMasterViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator)
}

// MARK: - MasterRouter Default Impl
extension MasterRouter where Self: MasterRouterTransitionable, Self: RouterIdentifiable {
    func setMasterViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    {
        setMasterViewControllerDerivedFrom(
            deriveViewController,
            animator: NavigationTransitionsAnimatorImpl()
        )
    }

    func setMasterViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator)
    {
        guard let masterTransitionsHandler = masterTransitionsHandler
            else { assert(false); return }
        
        let viewController = deriveViewController(
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