/// Описание аниматора перехода, выполняющего любые виды reset-анимаций
public enum ResettingTransitionsAnimatorBox {
    case SetNavigation(animator: SetNavigationTransitionsAnimator)
    case ResetNavigation(animator: ResetNavigationTransitionsAnimator)
    case Reset
    
    public func enableAnimations() {
        switch self {
        case .SetNavigation(let animator):
            animator.shouldAnimate = true
            
        case .ResetNavigation(let animator):
            animator.shouldAnimate = true
            
        case .Reset:
            break // no need for animations
        }
    }
    
    public func disableAnimations() {
        switch self {
        case .SetNavigation(let animator):
            animator.shouldAnimate = false
            
        case .ResetNavigation(let animator):
            animator.shouldAnimate = false
            
        case .Reset:
            break // no need for animations
        }
    }
}