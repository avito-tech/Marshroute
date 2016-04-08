import UIKit

// TODO: (tyusipov) вынести в отдельный файл
/// Описание аниматора перехода
public enum TransitionAnimatorBox {
    case Navigation(animator: NavigationTransitionsAnimator)
    case Popover(animator: PopoverTransitionsAnimator)
    
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









/// Описание параметров запуска любого вида анимаций
public enum TransitionAnimationLaunchingContext {
    case Navigation(launchingContext: NavigationAnimationLaunchingContext)
    case Popover(launchingContext: PopoverAnimationLaunchingContext)
}

// MARK: - convenience
public extension TransitionAnimationLaunchingContext {
    init(sourceAnimationLaunchingContext: TransitionAnimationLaunchingContext,
        targetViewController viewController: UIViewController)
    {
        switch sourceAnimationLaunchingContext {
        case .Navigation(let launchingContext):
            let updatedNavigationAnimationLaunchingContext = NavigationAnimationLaunchingContext(
                transitionStyle: launchingContext.transitionStyle,
                animationTargetParameters: NavigationAnimationTargetParameters(viewController: viewController),
                animator: launchingContext.animator
            )
            
            self = .Navigation(launchingContext: updatedNavigationAnimationLaunchingContext)
            
        case .Popover(let launchingContext):
            let updatedPopoverAnimationLaunchingContext = PopoverAnimationLaunchingContext(
                transitionStyle: launchingContext.transitionStyle,
                animationSourceParameters: launchingContext.animationSourceParameters,
                animationTargetParameters: PopoverAnimationTargetParameters(viewController: viewController),
                animator: launchingContext.animator
            )
            
            self = .Popover(launchingContext: updatedPopoverAnimationLaunchingContext)
        }
    }
}

// MARK: - convenience
extension TransitionAnimationLaunchingContext {
    var transitionAnimatorBox: TransitionAnimatorBox {
        switch self {
        case .Navigation(let launchingContext):
            return .Navigation(animator: launchingContext.animator)
        case .Popover(let launchingContext):
            return .Popover(animator: launchingContext.animator)
        }
    }
}

// MARK: - public methods
public extension TransitionAnimationLaunchingContext {
    var needsNavigationAnimationSourceParameters: Bool {
        switch self {
        case .Navigation(_):
            return true
        case .Popover(_):
            return false
        }
    }
    
    func launchAnimationOfPerformingTransition(navigationAnimationSourceParameters: NavigationAnimationSourceParameters? = nil)
    {
        launchAnimation(
            launchStyle: .LaunchPerforming,
            navigationAnimationSourceParameters: navigationAnimationSourceParameters
        )
    }
    
    func launchAnimationOfUndoingTransition(navigationAnimationSourceParameters: NavigationAnimationSourceParameters? = nil)
    {
        launchAnimation(
            launchStyle: .LaunchUndoing,
            navigationAnimationSourceParameters: navigationAnimationSourceParameters
        )
    }
    
    func launchAnimationOfResettingWithTransition(navigationAnimationSourceParameters: NavigationAnimationSourceParameters? = nil)
    {
        launchAnimation(
            launchStyle: .LaunchResetting,
            navigationAnimationSourceParameters: navigationAnimationSourceParameters
        )
    }
}

// MARK: - helpers
private extension TransitionAnimationLaunchingContext {
    enum LaunchStyle {
        case LaunchPerforming
        case LaunchUndoing
        case LaunchResetting
    }
    
    func launchAnimation(launchStyle launchStyle: LaunchStyle, navigationAnimationSourceParameters: NavigationAnimationSourceParameters? = nil)
    {
        switch self {
        case .Navigation(let launchingContext):
            guard let navigationController = navigationAnimationSourceParameters?.navigationController
                else { return }
            
            guard let targetViewController = launchingContext.animationTargetParameters.viewController
                else { return }
            
            let animationContext = NavigationAnimationContext(
                navigationController: navigationController,
                targetViewController: targetViewController,
                transitionStyle: launchingContext.transitionStyle
            )
            
            launchAnimation(animator: launchingContext.animator,
                animationContext: animationContext,
                launchStyle: launchStyle
            )
            
        case .Popover(let launchingContext):
            guard let popoverController = launchingContext.animationSourceParameters.popoverController
                else { return }
            
            let animationContext = PopoverAnimationContext(
                popoverController: popoverController,
                transitionStyle: launchingContext.transitionStyle)
            
            launchAnimation(animator: launchingContext.animator,
                animationContext: animationContext,
                launchStyle: launchStyle
            )
        }
    }
    
    func launchAnimation<A: TransitionsAnimator, C where C == A.AnimationContext>(
        animator animator: A,
        animationContext: C,
        launchStyle: LaunchStyle)
    {
        switch launchStyle {
        case .LaunchPerforming:
            animator.animatePerformingTransition(animationContext: animationContext)
            
        case .LaunchUndoing:
            animator.animateUndoingTransition(animationContext: animationContext)
            
        case .LaunchResetting:
            animator.animateResettingWithTransition(animationContext: animationContext)
        }
    }
}