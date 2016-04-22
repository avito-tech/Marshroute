/// Описание аниматора, выполняющего любой вид прямого или обратного перехода
public enum TransitionsAnimatorBox {
    case Modal(animator: ModalTransitionsAnimator)
    case ModalNavigation(animator: ModalNavigationTransitionsAnimator)
    case ModalEndpointNavigation(animator: ModalEndpointNavigationTransitionsAnimator)
    case Navigation(animator: NavigationTransitionsAnimator)
    case Popover(animator: PopoverTransitionsAnimator)
    case PopoverNavigation(animator: PopoverNavigationTransitionsAnimator)
    
    public func enableAnimations() {
        switch self {
        case .Modal(let animator):
            animator.shouldAnimate = true
            
        case .ModalNavigation(let animator):
            animator.shouldAnimate = true
            
        case .ModalEndpointNavigation(let animator):
            animator.shouldAnimate = true
            
        case .Navigation(let animator):
            animator.shouldAnimate = true
            
        case .Popover(let animator):
            animator.shouldAnimate = true
            
        case .PopoverNavigation(let animator):
            animator.shouldAnimate = true
        }
    }
    
    public func disableAnimations() {
        switch self {
        case .Modal(let animator):
            animator.shouldAnimate = false
            
        case .ModalNavigation(let animator):
            animator.shouldAnimate = false
            
        case .ModalEndpointNavigation(let animator):
            animator.shouldAnimate = false
            
        case .Navigation(let animator):
            animator.shouldAnimate = false
            
        case .Popover(let animator):
            animator.shouldAnimate = false
            
        case .PopoverNavigation(let animator):
            animator.shouldAnimate = false
        }
    }
}