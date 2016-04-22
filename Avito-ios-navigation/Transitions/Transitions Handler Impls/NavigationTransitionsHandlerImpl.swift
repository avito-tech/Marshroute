import UIKit

final public class NavigationTransitionsHandlerImpl: AnimatingTransitionsHandler {
    private weak var navigationController: UINavigationController?
    
    public init(navigationController: UINavigationController,
                transitionsCoordinator: TransitionsCoordinator)
    {
        self.navigationController = navigationController
        super.init(transitionsCoordinator: transitionsCoordinator)
    }
    
    // MARK: - TransitionAnimationsLauncher
    override public func launchPresentationAnimation(launchingContextBox launchingContextBox: PresentationAnimationLaunchingContextBox)
    {
        switch launchingContextBox {
        case .Modal(_):
            super.launchPresentationAnimation(launchingContextBox: launchingContextBox)
            
        case .ModalNavigation(_):
            super.launchPresentationAnimation(launchingContextBox: launchingContextBox)
            
        case .ModalEndpointNavigation(_):
            super.launchPresentationAnimation(launchingContextBox: launchingContextBox)
            
        case .Push(var launchingContext):
            guard let navigationController = navigationController
                else { return }
            
            // `Push` could be forwarded to a topmost `UINavigationController`,
            // so we should pass our navigation controller
            launchingContext.navigationController = navigationController
            
            let pushAnimationContext = PushAnimationContext(
                pushAnimationLaunchingContext: launchingContext
            )
            
            if let animationContext = pushAnimationContext {
                launchingContext.animator.animatePerformingTransition(animationContext: animationContext)
            }
            
        case .Popover(_):
            super.launchPresentationAnimation(launchingContextBox: launchingContextBox)
            
        case .PopoverNavigation(_):
            super.launchPresentationAnimation(launchingContextBox: launchingContextBox)
        }
    }
    
    override public func launchDismissalAnimation(launchingContextBox launchingContextBox: DismissalAnimationLaunchingContextBox)
    {
        switch launchingContextBox {
        case .Modal(_):
            super.launchDismissalAnimation(launchingContextBox: launchingContextBox)
            
        case .ModalNavigation(_):
            super.launchDismissalAnimation(launchingContextBox: launchingContextBox)
            
        case .ModalEndpointNavigation(_):
            super.launchDismissalAnimation(launchingContextBox: launchingContextBox)
            
        case .Pop(_):
            super.launchDismissalAnimation(launchingContextBox: launchingContextBox)
            
        case .Popover(_):
            super.launchDismissalAnimation(launchingContextBox: launchingContextBox)
            
        case .PopoverNavigation(_):
            super.launchDismissalAnimation(launchingContextBox: launchingContextBox)
        }
    }
    
    override public func launchResettingAnimation(launchingContextBox launchingContextBox: ResettingAnimationLaunchingContextBox)
    {
        switch launchingContextBox {
        case .SettingNavigationRoot(_):
            super.launchResettingAnimation(launchingContextBox: launchingContextBox)
            
        case .ResettingNavigationRoot(var launchingContext):
            guard let navigationController = navigationController
                else { return }
            
            // `ResetNavigation` is usually done in place, where the `UINavigationController` is unreachable,
            // so we should pass our navigation controller
            launchingContext.navigationController = navigationController
            
            let resettingAnimationContext = ResettingNavigationAnimationContext(
                resettingAnimationLaunchingContext: launchingContext
            )
            
            if let animationContext = resettingAnimationContext {
                launchingContext.animator.animateResettingWithTransition(animationContext: animationContext)
            }
            
        case .Registering:
            super.launchResettingAnimation(launchingContextBox: launchingContextBox)
            
        case .RegisteringEndpointNavigation:
            super.launchResettingAnimation(launchingContextBox: launchingContextBox)
        }
    }
}