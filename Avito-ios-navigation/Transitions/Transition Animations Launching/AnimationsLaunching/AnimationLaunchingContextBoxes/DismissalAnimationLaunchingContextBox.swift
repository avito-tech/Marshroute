import UIKit


/// Описание параметров запуска анимаций прямого перехода
public enum DismissalAnimationLaunchingContextBox {
    case Modal(launchingContext: ModalDismissalAnimationLaunchingContext)
    case ModalNavigation(launchingContext: ModalNavigationDismissalAnimationLaunchingContext)
    case ModalEndpointNavigation(launchingContext: ModalEndpointNavigationDismissalAnimationLaunchingContext)
    case ModalMasterDetail(launchingContext: ModalMasterDetailDismissalAnimationLaunchingContext)
    case Pop(launchingContext: PopAnimationLaunchingContext)
    case Popover(launchingContext: PopoverDismissalAnimationLaunchingContext)
    case PopoverNavigation(launchingContext: PopoverNavigationDismissalAnimationLaunchingContext)
    
    public init?(
        presentationAnimationLaunchingContextBox: PresentationAnimationLaunchingContextBox,
        targetViewController: UIViewController)
    {
        switch presentationAnimationLaunchingContextBox {
        case .Modal(let launchingContext):
            let modalDismissalAnimationLaunchingContext = ModalDismissalAnimationLaunchingContext(
                modalPresentationAnimationLaunchingContext: launchingContext,
                targetViewController: targetViewController
            )
            
            if let launchingContext = modalDismissalAnimationLaunchingContext {
                self = .Modal(launchingContext: launchingContext)
            } else {
                return nil
            }
            
        case .ModalNavigation(let launchingContext):
            let modalNavigationDismissalAnimationLaunchingContext = ModalNavigationDismissalAnimationLaunchingContext(
                modalNavigationPresentationAnimationLaunchingContext: launchingContext,
                targetViewController: targetViewController
            )
            
            if let launchingContext = modalNavigationDismissalAnimationLaunchingContext {
                self = .ModalNavigation(launchingContext: launchingContext)
            } else {
                return nil
            }
            
        case .ModalEndpointNavigation(let launchingContext):
            let modalEndpointNavigationDismissalAnimationLaunchingContext = ModalEndpointNavigationDismissalAnimationLaunchingContext(
                modalEndpointNavigationPresentationAnimationLaunchingContext: launchingContext,
                targetViewController: targetViewController
            )
            
            if let launchingContext = modalEndpointNavigationDismissalAnimationLaunchingContext {
                self = .ModalEndpointNavigation(launchingContext: launchingContext)
            } else {
                return nil
            }
            
        case .ModalMasterDetail(let launchingContext):
            let modalMasterDetailDismissalAnimationLaunchingContext = ModalMasterDetailDismissalAnimationLaunchingContext(
                modalPresentationAnimationLaunchingContext: launchingContext,
                targetViewController: targetViewController
            )
            
            if let launchingContext = modalMasterDetailDismissalAnimationLaunchingContext {
                self = .ModalMasterDetail(launchingContext: launchingContext)
            } else {
                return nil
            }
            
        case .Push(let launchingContext):
            let popAnimationLaunchingContext = PopAnimationLaunchingContext(
                pushAnimationLaunchingContext: launchingContext,
                targetViewController: targetViewController
            )
            
            if let launchingContext = popAnimationLaunchingContext {
                self = .Pop(launchingContext: launchingContext)
            } else {
                return nil
            }
            
        case .Popover(let launchingContext):
            let popoverDismissalAnimationLaunchingContext = PopoverDismissalAnimationLaunchingContext(
                popoverPresentationAnimationLaunchingContext: launchingContext,
                targetViewController: targetViewController
            )
            
            if let launchingContext = popoverDismissalAnimationLaunchingContext {
                self = .Popover(launchingContext: launchingContext)
            } else {
                return nil
            }
            
        case .PopoverNavigation(let launchingContext):
            let popoverNavigationDismissalAnimationLaunchingContext = PopoverNavigationDismissalAnimationLaunchingContext(
                popoverNavigationPresentationAnimationLaunchingContext: launchingContext,
                targetViewController: targetViewController
            )
            
            if let launchingContext = popoverNavigationDismissalAnimationLaunchingContext {
                self = .PopoverNavigation(launchingContext: launchingContext)
            } else {
                return nil
            }
        }
    }
    
    public var transitionsAnimatorBox: TransitionsAnimatorBox
    {
        switch self {
        case .Modal(let launchingContext):
            return .Modal(animator: launchingContext.animator)
            
        case .ModalNavigation(let launchingContext):
            return .ModalNavigation(animator: launchingContext.animator)
            
        case .ModalEndpointNavigation(let launchingContext):
            return .ModalEndpointNavigation(animator: launchingContext.animator)
            
        case .ModalMasterDetail(let launchingContext):
            return .ModalMasterDetail(animator: launchingContext.animator)
            
        case .Pop(let launchingContext):
            return .Navigation(animator: launchingContext.animator)
            
        case .Popover(let launchingContext):
            return .Popover(animator: launchingContext.animator)
            
        case .PopoverNavigation(let launchingContext):
            return .PopoverNavigation(animator: launchingContext.animator)
        }
    }
}