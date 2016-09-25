import Foundation

public protocol TransitionsCoordinatorDelegate: class {
    // Permissions
    func transitionsCoordinator(
        coordinator: TransitionsCoordinator,
        canForceTransitionsHandler transitionsHandler: TransitionsHandler,
        toLaunchResettingAnimationOfTransition context: ResettingTransitionContext,
        markedWithUserId userId: TransitionUserId)
    -> Bool
    
    func transitionsCoordinator(
        coordinator: TransitionsCoordinator,
        canForceTransitionsHandler transitionsHandler: TransitionsHandler,
        toLaunchPresentationAnimationOfTransition context: PresentationTransitionContext,
        markedWithUserId userId: TransitionUserId)
    -> Bool
    
    // Notifications
    func transitionsCoordinator(
        coordinator: TransitionsCoordinator,
        willForceTransitionsHandler transitionsHandler: TransitionsHandler,
        toLaunchResettingAnimationOfTransition context: ResettingTransitionContext)
    
    func transitionsCoordinator(
        coordinator: TransitionsCoordinator,
        willForceTransitionsHandler transitionsHandler: TransitionsHandler,
        toLaunchPresentationAnimationOfTransition context: PresentationTransitionContext)
    
    func transitionsCoordinator(
        coordinator: TransitionsCoordinator,
        willForceTransitionsHandler transitionsHandler: TransitionsHandler,
        toLaunchDismissalAnimationByAnimator animatorBox: TransitionsAnimatorBox,
        ofTransitionsAfterId transitionId: TransitionId)
    
    func transitionsCoordinator(
        coordinator: TransitionsCoordinator,
        willForceTransitionsHandler transitionsHandler: TransitionsHandler,
        toLaunchDismissalAnimationByAnimator animatorBox: TransitionsAnimatorBox,
        ofTransitionWithId transitionId: TransitionId)
}
