import Foundation

public protocol TransitionsCoordinatorDelegate: class {
    func transitionsCoordinator(
        coordinator coordinator: TransitionsCoordinator,
        canForceTransitionsHandler: TransitionsHandler,
        toLaunchResettingAnimationOfTransition: ResettingTransitionContext)
    -> Bool
    
    func transitionsCoordinator(
        coordinator coordinator: TransitionsCoordinator,
        canForceTransitionsHandler: TransitionsHandler,
        toLaunchPresentationAnimationOfTransition: PresentationTransitionContext)
    -> Bool
    
    func transitionsCoordinator(
        coordinator coordinator: TransitionsCoordinator,
        willForceTransitionsHandler: TransitionsHandler,
        toLaunchDismissalAnimationByAnimator animatorBox: TransitionsAnimatorBox,
        ofTransitionsAfterId transitionId: TransitionId)
    
    func transitionsCoordinator(
        coordinator coordinator: TransitionsCoordinator,
        willForceTransitionsHandler: TransitionsHandler,
        toLaunchDismissalAnimationByAnimator animatorBox: TransitionsAnimatorBox,
        ofTransitionWithId transitionId: TransitionId)
}