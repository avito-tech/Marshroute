import UIKit


/// Описание параметров запуска анимаций прямого перехода
public enum DismissalAnimationLaunchingContextBox {
    case Modal(launchingContext: ModalDismissalAnimationLaunchingContext)
    case ModalNavigation(launchingContext: ModalNavigationDismissalAnimationLaunchingContext)
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
    
    public func launchDismissalAnimation()
    {
        switch self {
        case .Modal(let launchingContext):
            let modalDismissalAnimationContext = ModalDismissalAnimationContext(
                modalDismissalAnimationLaunchingContext: launchingContext
            )
            
            launchingContext.animator.animateUndoingTransition(animationContext: modalDismissalAnimationContext)
            
        case .ModalNavigation(let launchingContext):
            let modalNavigationDismissalAnimationContext = ModalNavigationDismissalAnimationContext(
                modalNavigationDismissalAnimationLaunchingContext: launchingContext
            )
            
            launchingContext.animator.animateUndoingTransition(animationContext: modalNavigationDismissalAnimationContext)
            
        case .Pop(let launchingContext):
            let popAnimationContext = PopAnimationContext(
                popAnimationLaunchingContext: launchingContext
            )
        
            launchingContext.animator.animateUndoingTransition(animationContext: popAnimationContext)
            
        case .Popover(let launchingContext):
            let popoverDismissalAnimationContext = PopoverDismissalAnimationContext(
                popoverDismissalAnimationLaunchingContext: launchingContext
            )
            
            launchingContext.animator.animateUndoingTransition(animationContext: popoverDismissalAnimationContext)
            
        case .PopoverNavigation(let launchingContext):
            let popoverNavigationDismissalAnimationContext = PopoverNavigationDismissalAnimationContext(
                popoverNavigationDismissalAnimationLaunchingContext: launchingContext
            )
            
            launchingContext.animator.animateUndoingTransition(animationContext: popoverNavigationDismissalAnimationContext)
        }
    }
}