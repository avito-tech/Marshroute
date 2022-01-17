import Foundation

public protocol TransitionsCoordinatorDelegate: AnyObject {
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
    
    func transitionsCoordinator(
        coordinator: TransitionsCoordinator,
        canUndoChainedTransition chainedTransition: RestoredTransitionContext?,
        andPushTransitions pushTransitions: [RestoredTransitionContext]?,
        forTransitionsHandler animatingTransitionsHandler: AnimatingTransitionsHandler,
        transitionId: TransitionId)
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
