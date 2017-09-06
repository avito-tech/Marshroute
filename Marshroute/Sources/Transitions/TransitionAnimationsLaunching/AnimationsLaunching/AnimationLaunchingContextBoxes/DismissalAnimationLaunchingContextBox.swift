import UIKit

/// Описание параметров запуска анимаций прямого перехода
public enum DismissalAnimationLaunchingContextBox {
    case modal(launchingContext: ModalDismissalAnimationLaunchingContext)
    case modalNavigation(launchingContext: ModalNavigationDismissalAnimationLaunchingContext)
    case modalEndpointNavigation(launchingContext: ModalEndpointNavigationDismissalAnimationLaunchingContext)
    case modalMasterDetail(launchingContext: ModalMasterDetailDismissalAnimationLaunchingContext)
    case pop(launchingContext: PopAnimationLaunchingContext)
    case popover(launchingContext: PopoverDismissalAnimationLaunchingContext)
    case popoverNavigation(launchingContext: PopoverNavigationDismissalAnimationLaunchingContext)
    
    public init?(
        presentationAnimationLaunchingContextBox: PresentationAnimationLaunchingContextBox,
        targetViewController: UIViewController)
    {
        switch presentationAnimationLaunchingContextBox {
        case .modal(let launchingContext):
            let modalDismissalAnimationLaunchingContext = ModalDismissalAnimationLaunchingContext(
                modalPresentationAnimationLaunchingContext: launchingContext,
                targetViewController: targetViewController
            )
            
            if let launchingContext = modalDismissalAnimationLaunchingContext {
                self = .modal(launchingContext: launchingContext)
            } else {
                return nil
            }
            
        case .modalNavigation(let launchingContext):
            let modalNavigationDismissalAnimationLaunchingContext = ModalNavigationDismissalAnimationLaunchingContext(
                modalNavigationPresentationAnimationLaunchingContext: launchingContext,
                targetViewController: targetViewController
            )
            
            if let launchingContext = modalNavigationDismissalAnimationLaunchingContext {
                self = .modalNavigation(launchingContext: launchingContext)
            } else {
                return nil
            }
            
        case .modalEndpointNavigation(let launchingContext):
            let modalEndpointNavigationDismissalAnimationLaunchingContext = ModalEndpointNavigationDismissalAnimationLaunchingContext(
                modalEndpointNavigationPresentationAnimationLaunchingContext: launchingContext,
                targetViewController: targetViewController
            )
            
            if let launchingContext = modalEndpointNavigationDismissalAnimationLaunchingContext {
                self = .modalEndpointNavigation(launchingContext: launchingContext)
            } else {
                return nil
            }
            
        case .modalMasterDetail(let launchingContext):
            let modalMasterDetailDismissalAnimationLaunchingContext = ModalMasterDetailDismissalAnimationLaunchingContext(
                modalPresentationAnimationLaunchingContext: launchingContext,
                targetViewController: targetViewController
            )
            
            if let launchingContext = modalMasterDetailDismissalAnimationLaunchingContext {
                self = .modalMasterDetail(launchingContext: launchingContext)
            } else {
                return nil
            }
            
        case .push(let launchingContext):
            let popAnimationLaunchingContext = PopAnimationLaunchingContext(
                pushAnimationLaunchingContext: launchingContext,
                targetViewController: targetViewController
            )
            
            if let launchingContext = popAnimationLaunchingContext {
                self = .pop(launchingContext: launchingContext)
            } else {
                return nil
            }
            
        case .popover(let launchingContext):
            let popoverDismissalAnimationLaunchingContext = PopoverDismissalAnimationLaunchingContext(
                popoverPresentationAnimationLaunchingContext: launchingContext,
                targetViewController: targetViewController
            )
            
            if let launchingContext = popoverDismissalAnimationLaunchingContext {
                self = .popover(launchingContext: launchingContext)
            } else {
                return nil
            }
            
        case .popoverNavigation(let launchingContext):
            let popoverNavigationDismissalAnimationLaunchingContext = PopoverNavigationDismissalAnimationLaunchingContext(
                popoverNavigationPresentationAnimationLaunchingContext: launchingContext,
                targetViewController: targetViewController
            )
            
            if let launchingContext = popoverNavigationDismissalAnimationLaunchingContext {
                self = .popoverNavigation(launchingContext: launchingContext)
            } else {
                return nil
            }
        }
    }
    
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
            
        case .pop(let launchingContext):
            return .navigation(animator: launchingContext.animator)
            
        case .popover(let launchingContext):
            return .popover(animator: launchingContext.animator)
            
        case .popoverNavigation(let launchingContext):
            return .popoverNavigation(animator: launchingContext.animator)
        }
    }
}
