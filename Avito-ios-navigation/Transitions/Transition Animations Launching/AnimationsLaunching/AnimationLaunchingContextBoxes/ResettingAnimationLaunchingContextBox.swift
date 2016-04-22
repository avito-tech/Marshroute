import UIKit

/// Описание параметров запуска reset-анимаций
public enum ResettingAnimationLaunchingContextBox {
    case Reset(launchingContext: ResettingAnimationLaunchingContext)

    public var needsNavigationControllerForResettingAnimation: Bool
    {
        switch self {
        case .Reset(_):
            return true
        }
    }
    
    public func launchResettingAnimation(navigationController navigationController: UINavigationController?)
    {
        guard needsNavigationControllerForResettingAnimation == (navigationController != nil)
            else { return }
        
        switch self {
        case .Reset(var launchingContext):
            launchingContext.navigationController = navigationController
            
            let resettingAnimationContext = ResettingAnimationContext(
                resettingAnimationLaunchingContext: launchingContext
            )
            
            if let animationContext = resettingAnimationContext {
                launchingContext.animator.animateResettingWithTransition(animationContext: animationContext)
            }
        }
    }
}