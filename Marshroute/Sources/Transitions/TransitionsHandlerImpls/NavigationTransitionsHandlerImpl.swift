import UIKit

final public class NavigationTransitionsHandlerImpl: AnimatingTransitionsHandler {
    fileprivate weak var navigationController: UINavigationController?
    
    public init(navigationController: UINavigationController,
                transitionsCoordinator: TransitionsCoordinator)
    {
        self.navigationController = navigationController
        super.init(transitionsCoordinator: transitionsCoordinator)
    }
    
    // MARK: - TransitionAnimationsLauncher
    override public func launchPresentationAnimation(launchingContextBox: inout PresentationAnimationLaunchingContextBox)
    {
        switch launchingContextBox {
        case .modal:
            super.launchPresentationAnimation(launchingContextBox: &launchingContextBox)
            
        case .modalNavigation:
            super.launchPresentationAnimation(launchingContextBox: &launchingContextBox)
            
        case .modalEndpointNavigation:
            super.launchPresentationAnimation(launchingContextBox: &launchingContextBox)
            
        case .modalMasterDetail:
            super.launchPresentationAnimation(launchingContextBox: &launchingContextBox)
            
        case .push(var launchingContext):
            guard let navigationController = navigationController
                else { debugPrint("no `UINavigationController` to `pushViewController:animated`"); return }
            
            // `Push` could be forwarded to a topmost `UINavigationController`,
            // so we should pass our navigation controller
            launchingContext.navigationController = navigationController
            
            let pushAnimationContext = PushAnimationContext(
                pushAnimationLaunchingContext: launchingContext
            )
            
            if let animationContext = pushAnimationContext {
                launchingContext.animator.animatePerformingTransition(animationContext: animationContext)
            }
            
            launchingContextBox = .push(launchingContext: launchingContext)
            
        case .popover:
            super.launchPresentationAnimation(launchingContextBox: &launchingContextBox)
            
        case .popoverNavigation:
            super.launchPresentationAnimation(launchingContextBox: &launchingContextBox)
        }
    }
    
    override public func launchDismissalAnimation(launchingContextBox: DismissalAnimationLaunchingContextBox)
    {
        switch launchingContextBox {
        case .modal:
            super.launchDismissalAnimation(launchingContextBox: launchingContextBox)
            
        case .modalNavigation:
            super.launchDismissalAnimation(launchingContextBox: launchingContextBox)
            
        case .modalEndpointNavigation:
            super.launchDismissalAnimation(launchingContextBox: launchingContextBox)
            
        case .modalMasterDetail:
            super.launchDismissalAnimation(launchingContextBox: launchingContextBox)
            
        case .pop:
            super.launchDismissalAnimation(launchingContextBox: launchingContextBox)
            
        case .popover:
            super.launchDismissalAnimation(launchingContextBox: launchingContextBox)
            
        case .popoverNavigation:
            super.launchDismissalAnimation(launchingContextBox: launchingContextBox)
        }
    }
    
    override public func launchResettingAnimation(launchingContextBox: inout ResettingAnimationLaunchingContextBox)
    {
        switch launchingContextBox {
        case .settingNavigationRoot:
            super.launchResettingAnimation(launchingContextBox: &launchingContextBox)
            
        case .resettingNavigationRoot(var launchingContext):
            guard let navigationController = navigationController
                else { debugPrint("no `UINavigationController` to `setViewControllers:animated`"); return }
            
            // `ResetNavigation` is usually done in place, where the `UINavigationController` is unreachable,
            // so we should pass our navigation controller
            launchingContext.navigationController = navigationController
            
            let resettingAnimationContext = ResettingNavigationAnimationContext(
                resettingAnimationLaunchingContext: launchingContext
            )
            
            if let animationContext = resettingAnimationContext {
                launchingContext.animator.animateResettingWithTransition(animationContext: animationContext)
            }
            
            launchingContextBox = .resettingNavigationRoot(launchingContext: launchingContext)
            
        case .registering:
            super.launchResettingAnimation(launchingContextBox: &launchingContextBox)
            
        case .registeringEndpointNavigation:
            super.launchResettingAnimation(launchingContextBox: &launchingContextBox)
        }
    }
}
