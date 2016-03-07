import UIKit

public enum ModalTransitionStyle: Int {
    case CoverVertical
    case FlipHorizontal
    case CrossDissolve
    case PartialCurl
}

public enum ModalPresentationStyle : Int {
    case FullScreen
    case PageSheet
    case FormSheet
    case CurrentContext
    case Custom
    case None
}

public final class NavigationModalTransitionsAnimator: NavigationTransitionsAnimator {
    public let modalTransitionStyle: ModalTransitionStyle
    public let modalPresentationStyle: ModalPresentationStyle
    
    public init(
        modalTransitionStyle: ModalTransitionStyle?,
        modalPresentationStyle: ModalPresentationStyle?)
    {
        self.modalTransitionStyle = modalTransitionStyle ?? .CoverVertical
        self.modalPresentationStyle = modalPresentationStyle ?? .FullScreen

        super.init()
    }
    
    override public func animatePerformingTransition(animationContext context: NavigationAnimationContext)
    {
        switch context.transitionStyle {
        case .Modal:
            
            if let modalTransitionStyle = UIModalTransitionStyle(rawValue: modalTransitionStyle.rawValue) {
                context.targetViewController.modalTransitionStyle = modalTransitionStyle
            }
            
            if let modalPresentationStyle = UIModalPresentationStyle(rawValue: modalPresentationStyle.rawValue) {
                context.targetViewController.modalPresentationStyle = modalPresentationStyle
            }
            
        default:
            break
        }
        
        super.animatePerformingTransition(animationContext: context)
    }
}