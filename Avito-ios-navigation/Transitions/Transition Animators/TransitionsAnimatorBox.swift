/// Описание аниматора перехода
public enum TransitionsAnimatorBox {
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