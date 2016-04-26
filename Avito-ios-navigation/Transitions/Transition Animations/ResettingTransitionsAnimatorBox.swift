/// Описание всех аниматоров, выполняющих reset-переходы
public enum ResettingTransitionsAnimatorBox {
    case SettingNavigationRoot(animator: SetNavigationTransitionsAnimator)
    case ResettingNavigationRoot(animator: ResetNavigationTransitionsAnimator)
    case Registering
    case RegisteringEndpointNavigation
    
    public func enableAnimations() {
        switch self {
        case .SettingNavigationRoot(let animator):
            animator.shouldAnimate = true
            
        case .ResettingNavigationRoot(let animator):
            animator.shouldAnimate = true
            
        case .Registering:
            break // no need for animations
            
        case .RegisteringEndpointNavigation:
            break // no need for animations
        }
    }
    
    public func disableAnimations() {
        switch self {
        case .SettingNavigationRoot(let animator):
            animator.shouldAnimate = false
            
        case .ResettingNavigationRoot(let animator):
            animator.shouldAnimate = false
            
        case .Registering:
            break // no need for animations
            
        case .RegisteringEndpointNavigation:
            break // no need for animations
        }
    }
}