import UIKit

protocol MasterRouter: class {
    func setMasterViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController)
    
    func setMasterViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
        animator: NavigationTransitionsAnimator)
}

// MARK: - MasterRouter Default Impl
extension MasterRouter where Self: MasterRouterTransitionable, Self: RouterIdentifiable {
    func setMasterViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController)
    {
        setMasterViewControllerDerivedFrom(
            deriveViewController,
            animator: NavigationTransitionsAnimator()
        )
    }
    
    func setMasterViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    {
        guard let masterTransitionsHandlerBox = masterTransitionsHandlerBox
            else { assert(false); return }
        guard let animatingMasterTransitionsHandler = masterTransitionsHandlerBox.unboxAnimatingTransitionsHandler()
            else { assert(false); return }
        
        let viewController = deriveViewController(
            transitionId: transitionId,
            transitionsHandlerBox: masterTransitionsHandlerBox)
        
        let resetMasterContext = ForwardTransitionContext(
            resettingWithViewController: viewController,
            animatingTransitionsHandler: animatingMasterTransitionsHandler,
            animator: animator,
            transitionId: transitionId)
        
        animatingMasterTransitionsHandler.resetWithTransition(context: resetMasterContext)
    }
}