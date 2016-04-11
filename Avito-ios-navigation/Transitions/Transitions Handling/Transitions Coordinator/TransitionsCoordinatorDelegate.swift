import Foundation

public protocol TransitionsCoordinatorDelegate: class {
    func transitionsCoordinator(
        coordinator coordinator: TransitionsCoordinator,
        willLaunchResettingAnimation animatorBox: TransitionsAnimatorBox,
        ofTransitionWith transitionId: TransitionId)
    
    func transitionsCoordinator(
        coordinator coordinator: TransitionsCoordinator,
        willLaunchPerfromingAnimation animatorBox: TransitionsAnimatorBox,
        ofTransitionWithId transitionId: TransitionId)
    
    func transitionsCoordinator(
        coordinator coordinator: TransitionsCoordinator,
        willLaunchUndoingAnimation animatorBox: TransitionsAnimatorBox,
        ofTransitionsAfterId transitionId: TransitionId)
    
    func transitionsCoordinator(
        coordinator coordinator: TransitionsCoordinator,
        willLaunchUndoingAnimation animatorBox: TransitionsAnimatorBox,
        ofTransitionWithId transitionId: TransitionId)
}
