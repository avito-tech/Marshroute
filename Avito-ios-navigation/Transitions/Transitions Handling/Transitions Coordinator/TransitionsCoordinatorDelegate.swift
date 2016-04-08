import Foundation

public protocol TransitionsCoordinatorDelegate: class {
    func transitionsCoordinator(
        coordinator coordinator: TransitionsCoordinator,
        willLaunchResettingAnimation animatorBox: TransitionAnimatorBox,
        ofTransitionWith transitionId: TransitionId)
    
    func transitionsCoordinator(
        coordinator coordinator: TransitionsCoordinator,
        willLaunchPerfromingAnimation animatorBox: TransitionAnimatorBox,
        ofTransitionWithId transitionId: TransitionId)
    
    func transitionsCoordinator(
        coordinator coordinator: TransitionsCoordinator,
        willLaunchUndoingAnimation animatorBox: TransitionAnimatorBox,
        ofTransitionsAfterId transitionId: TransitionId)
    
    func transitionsCoordinator(
        coordinator coordinator: TransitionsCoordinator,
        willLaunchUndoingAnimation animatorBox: TransitionAnimatorBox,
        ofTransitionWithId transitionId: TransitionId)
}
