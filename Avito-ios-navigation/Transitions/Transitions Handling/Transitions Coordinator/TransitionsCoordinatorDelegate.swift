import Foundation

public enum TransitionAnimationContext {
    case Navigation(animator: NavigationTransitionsAnimator)
    case Popover(animator: PopoverTransitionsAnimator)
    
    public func becomeAnimated() {
        switch self {
        case .Navigation(let animator):
            animator.becomeAnimated()
        case .Popover(let animator):
            animator.becomeAnimated()
        }
    }
    
    public func becomeNotAnimated() {
        switch self {
        case .Navigation(let animator):
            animator.becomeNotAnimated()
        case .Popover(let animator):
            animator.becomeNotAnimated()
        }
    }
}

public protocol TransitionsCoordinatorDelegate: class {
    func transitionsCoordinator(
        coordinator coordinator: TransitionsCoordinator,
        willLaunchResettingAnimation context: TransitionAnimationContext,
        ofTransitionWith transitionId: TransitionId)
    
    func transitionsCoordinator(
        coordinator coordinator: TransitionsCoordinator,
        willLaunchPerfromingAnimation context: TransitionAnimationContext,
        ofTransitionWithId transitionId: TransitionId)
    
    func transitionsCoordinator(
        coordinator coordinator: TransitionsCoordinator,
        willLaunchUndoingAnimation context: TransitionAnimationContext,
        ofTransitionsAfterId transitionId: TransitionId)
    
    func transitionsCoordinator(
        coordinator coordinator: TransitionsCoordinator,
        willLaunchUndoingAnimation context: TransitionAnimationContext,
        ofTransitionWithId transitionId: TransitionId)
}
