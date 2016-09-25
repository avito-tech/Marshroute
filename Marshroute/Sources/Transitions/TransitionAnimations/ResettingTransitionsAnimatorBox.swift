/// Описание всех аниматоров, выполняющих reset-переходы
public enum ResettingTransitionsAnimatorBox {
    case settingNavigationRoot(animator: SetNavigationTransitionsAnimator)
    case resettingNavigationRoot(animator: ResetNavigationTransitionsAnimator)
    case registering
    case registeringEndpointNavigation
    
    public func enableAnimations() {
        switch self {
        case .settingNavigationRoot(let animator):
            animator.shouldAnimate = true
            
        case .resettingNavigationRoot(let animator):
            animator.shouldAnimate = true
            
        case .registering:
            break // no need for animations
            
        case .registeringEndpointNavigation:
            break // no need for animations
        }
    }
    
    public func disableAnimations() {
        switch self {
        case .settingNavigationRoot(let animator):
            animator.shouldAnimate = false
            
        case .resettingNavigationRoot(let animator):
            animator.shouldAnimate = false
            
        case .registering:
            break // no need for animations
            
        case .registeringEndpointNavigation:
            break // no need for animations
        }
    }
}
