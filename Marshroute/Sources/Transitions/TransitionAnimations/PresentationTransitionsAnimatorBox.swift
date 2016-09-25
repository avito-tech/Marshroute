/// Описание всех аниматоров, выполняющих прямые и обратные переходы
public enum TransitionsAnimatorBox {
    case modal(animator: ModalTransitionsAnimator)
    case modalNavigation(animator: ModalNavigationTransitionsAnimator)
    case modalEndpointNavigation(animator: ModalEndpointNavigationTransitionsAnimator)
    case modalMasterDetail(animator: ModalMasterDetailTransitionsAnimator)
    case navigation(animator: NavigationTransitionsAnimator)
    case popover(animator: PopoverTransitionsAnimator)
    case popoverNavigation(animator: PopoverNavigationTransitionsAnimator)
    
    public func enableAnimations() {
        switch self {
        case .modal(let animator):
            animator.shouldAnimate = true
            
        case .modalNavigation(let animator):
            animator.shouldAnimate = true
            
        case .modalEndpointNavigation(let animator):
            animator.shouldAnimate = true
          
        case .modalMasterDetail(let animator):
            animator.shouldAnimate = true
            
        case .navigation(let animator):
            animator.shouldAnimate = true
            
        case .popover(let animator):
            animator.shouldAnimate = true
            
        case .popoverNavigation(let animator):
            animator.shouldAnimate = true
        }
    }
    
    public func disableAnimations() {
        switch self {
        case .modal(let animator):
            animator.shouldAnimate = false
            
        case .modalNavigation(let animator):
            animator.shouldAnimate = false
            
        case .modalEndpointNavigation(let animator):
            animator.shouldAnimate = false
            
        case .modalMasterDetail(let animator):
            animator.shouldAnimate = false
            
        case .navigation(let animator):
            animator.shouldAnimate = false
            
        case .popover(let animator):
            animator.shouldAnimate = false
            
        case .popoverNavigation(let animator):
            animator.shouldAnimate = false
        }
    }
}
