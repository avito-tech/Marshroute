import Foundation

public enum TransitionAnimatorBox {
    case Navigation(animator: NavigationTransitionsAnimator)
    case Popover(animator: PopoverTransitionsAnimator)
    
    public func enableAnimations() {
        switch self {
        case .Navigation(let animator):
            animator.shouldAnimate = true
        case .Popover(let animator):
            animator.shouldAnimate = true
        }
    }
    
    public func disableAnimations() {
        switch self {
        case .Navigation(let animator):
            animator.shouldAnimate = false
        case .Popover(let animator):
            animator.shouldAnimate = false
        }
    }
}

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
