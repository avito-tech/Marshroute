import UIKit

/// Описание параметров запуска анимаций обратного перехода
public enum PresentationAnimationLaunchingContextBox {
    case Modal(launchingContext: ModalPresentationAnimationLaunchingContext)
    case ModalNavigation(launchingContext: ModalNavigationPresentationAnimationLaunchingContext)
    case Push(launchingContext: PushAnimationLaunchingContext)
    case Popover(launchingContext: PopoverPresentationAnimationLaunchingContext)
    case PopoverNavigation(launchingContext: PopoverNavigationPresentationAnimationLaunchingContext)
    
    public var transitionsAnimatorBox: TransitionsAnimatorBox
    {
        switch self {
        case .Modal(let launchingContext):
            return .Modal(animator: launchingContext.animator)
            
        case .ModalNavigation(let launchingContext):
            return .ModalNavigation(animator: launchingContext.animator)
            
        case .Push(let launchingContext):
            return .Navigation(animator: launchingContext.animator)
            
        case .Popover(let launchingContext):
            return .Popover(animator: launchingContext.animator)
            
        case .PopoverNavigation(let launchingContext):
            return .PopoverNavigation(animator: launchingContext.animator)
        }
    }
    
    public var needsNavigationControllerForPresentationAnimation: Bool
    {
        switch self {
        case .Modal(_):
            return false
            
        case .ModalNavigation(_):
            return false
            
        case .Push(_):
            return true
            
        case .Popover(_):
            return false
            
        case .PopoverNavigation(_):
            return false
        }
    }
    
    public func launchPresentationAnimation(navigationController navigationController: UINavigationController? = nil)
    {
        guard needsNavigationControllerForPresentationAnimation == (navigationController != nil)
            else { return }
        
        switch self {
        case .Modal(let launchingContext):
            let modalPresentationAnimationContext = ModalPresentationAnimationContext(
                modalPresentationAnimationLaunchingContext: launchingContext
            )
            
            if let animationContext = modalPresentationAnimationContext {
                launchingContext.animator.animatePerformingTransition(animationContext: animationContext)
            }
            
        case .ModalNavigation(let launchingContext):
            let modalNavigationPresentationAnimationContext = ModalNavigationPresentationAnimationContext(
                modalNavigationPresentationAnimationLaunchingContext: launchingContext
            )
            
            if let animationContext = modalNavigationPresentationAnimationContext {
                launchingContext.animator.animatePerformingTransition(animationContext: animationContext)
            }
            
        case .Push(var launchingContext):
            launchingContext.navigationController = navigationController
            
            let pushAnimationContext = PushAnimationContext(
                pushAnimationLaunchingContext: launchingContext
            )
            
            if let animationContext = pushAnimationContext {
                launchingContext.animator.animatePerformingTransition(animationContext: animationContext)
            }
            
        case .Popover(let launchingContext):
            let popoverPresentationAnimationContext = PopoverPresentationAnimationContext(
                popoverPresentationAnimationLaunchingContext: launchingContext
            )
            
            if let animationContext = popoverPresentationAnimationContext {
                launchingContext.animator.animatePerformingTransition(animationContext: animationContext)
            }
            
        case .PopoverNavigation(let launchingContext):
            let popoverNavigationPresentationAnimationContext = PopoverNavigationPresentationAnimationContext(
                popoverNavigationPresentationAnimationLaunchingContext: launchingContext
            )
            
            if let animationContext = popoverNavigationPresentationAnimationContext {
                launchingContext.animator.animatePerformingTransition(animationContext: animationContext)
            }
        }
    }
}