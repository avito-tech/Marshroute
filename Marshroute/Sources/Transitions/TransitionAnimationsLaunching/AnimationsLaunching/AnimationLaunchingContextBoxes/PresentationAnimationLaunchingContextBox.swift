import UIKit

/// Описание параметров запуска анимаций прямого перехода
public enum PresentationAnimationLaunchingContextBox {
    case modal(launchingContext: ModalPresentationAnimationLaunchingContext)
    case modalNavigation(launchingContext: ModalNavigationPresentationAnimationLaunchingContext)
    case modalEndpointNavigation(launchingContext: ModalEndpointNavigationPresentationAnimationLaunchingContext)
    case modalMasterDetail(launchingContext: ModalMasterDetailPresentationAnimationLaunchingContext)
    case push(launchingContext: PushAnimationLaunchingContext)
    case popover(launchingContext: PopoverPresentationAnimationLaunchingContext)
    case popoverNavigation(launchingContext: PopoverNavigationPresentationAnimationLaunchingContext)
    
    public var transitionsAnimatorBox: TransitionsAnimatorBox
    {
        switch self {
        case .modal(let launchingContext):
            return .modal(animator: launchingContext.animator)
            
        case .modalNavigation(let launchingContext):
            return .modalNavigation(animator: launchingContext.animator)
            
        case .modalEndpointNavigation(let launchingContext):
            return .modalEndpointNavigation(animator: launchingContext.animator)
            
        case .modalMasterDetail(let launchingContext):
            return .modalMasterDetail(animator: launchingContext.animator)
            
        case .push(let launchingContext):
            return .navigation(animator: launchingContext.animator)
            
        case .popover(let launchingContext):
            return .popover(animator: launchingContext.animator)
            
        case .popoverNavigation(let launchingContext):
            return .popoverNavigation(animator: launchingContext.animator)
        }
    }
    
    public mutating func appendSourceViewController(_ sourceViewController: UIViewController)
    {
        switch self {
        case .modal(var launchingContext):
            launchingContext.sourceViewController = sourceViewController
            self = .modal(launchingContext: launchingContext)
            
        case .modalNavigation(var launchingContext):
            launchingContext.sourceViewController = sourceViewController
            self = .modalNavigation(launchingContext: launchingContext)
            
        case .modalEndpointNavigation(var launchingContext):
            launchingContext.sourceViewController = sourceViewController
            self = .modalEndpointNavigation(launchingContext: launchingContext)
            
        case .modalMasterDetail(var launchingContext):
            launchingContext.sourceViewController = sourceViewController
            self = .modalMasterDetail(launchingContext: launchingContext)
            
        case .push(var launchingContext):
            launchingContext.sourceViewController = sourceViewController
            self = .push(launchingContext: launchingContext)
            
        case .popover(var launchingContext):
            launchingContext.sourceViewController = sourceViewController
            self = .popover(launchingContext: launchingContext)
            
        case .popoverNavigation(var launchingContext):
            launchingContext.sourceViewController = sourceViewController
            self = .popoverNavigation(launchingContext: launchingContext)
        }
    }
}
