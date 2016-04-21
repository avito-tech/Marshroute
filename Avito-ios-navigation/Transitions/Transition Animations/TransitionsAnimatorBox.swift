/// Описание аниматора перехода
public enum TransitionsAnimatorBox {
    case Modal(animator: ModalTransitionsAnimator)
    case ModalNavigation(animator: ModalNavigationTransitionsAnimator)
    case Navigation(animator: NavigationTransitionsAnimator)
    case Popover(animator: PopoverTransitionsAnimator)
    case PopoverNavigation(animator: PopoverNavigationTransitionsAnimator)
    case Reset(animator: ResetTransitionsAnimator)
    
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