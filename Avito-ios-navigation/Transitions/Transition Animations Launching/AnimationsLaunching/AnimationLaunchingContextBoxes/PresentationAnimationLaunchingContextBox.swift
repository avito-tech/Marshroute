import UIKit

/// Описание параметров запуска анимаций прямого перехода
public enum PresentationAnimationLaunchingContextBox {
    case Modal(launchingContext: ModalPresentationAnimationLaunchingContext)
    case ModalNavigation(launchingContext: ModalNavigationPresentationAnimationLaunchingContext)
    case ModalEndpointNavigation(launchingContext: ModalEndpointNavigationPresentationAnimationLaunchingContext)
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
            
        case .ModalEndpointNavigation(let launchingContext):
            return .ModalEndpointNavigation(animator: launchingContext.animator)
            
        case .Push(let launchingContext):
            return .Navigation(animator: launchingContext.animator)
            
        case .Popover(let launchingContext):
            return .Popover(animator: launchingContext.animator)
            
        case .PopoverNavigation(let launchingContext):
            return .PopoverNavigation(animator: launchingContext.animator)
        }
    }
    
    public mutating func appendSourceViewController(sourceViewController: UIViewController)
    {
        switch self {
        case .Modal(var launchingContext):
            launchingContext.sourceViewController = sourceViewController
            
        case .ModalNavigation(var launchingContext):
            launchingContext.sourceViewController = sourceViewController
            
        case .ModalEndpointNavigation(var launchingContext):
            launchingContext.sourceViewController = sourceViewController
            
        case .Push(var launchingContext):
            launchingContext.sourceViewController = sourceViewController
            
        case .Popover(var launchingContext):
            launchingContext.sourceViewController = sourceViewController
            
        case .PopoverNavigation(var launchingContext):
            launchingContext.sourceViewController = sourceViewController
        }
    }
}