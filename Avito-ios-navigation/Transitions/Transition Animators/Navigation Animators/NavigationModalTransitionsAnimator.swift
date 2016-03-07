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
    public let sourceModalTransitionStyle: ModalTransitionStyle
    public let sourceModalPresentationStyle: ModalPresentationStyle
    public let targetModalTransitionStyle: ModalTransitionStyle
    public let targetModalPresentationStyle: ModalPresentationStyle
    
    public init(
        sourceModalTransitionStyle: ModalTransitionStyle?,
        sourceModalPresentationStyle: ModalPresentationStyle?,
        targetModalTransitionStyle: ModalTransitionStyle?,
        targetModalPresentationStyle: ModalPresentationStyle?)
    {
        self.sourceModalTransitionStyle = sourceModalTransitionStyle ?? .CoverVertical
        self.sourceModalPresentationStyle = sourceModalPresentationStyle ?? .FullScreen
        self.targetModalTransitionStyle = targetModalTransitionStyle ?? .CoverVertical
        self.targetModalPresentationStyle = targetModalPresentationStyle ?? .FullScreen

        super.init()
    }
    
    override public func animatePerformingTransition(animationContext context: NavigationAnimationContext)
    {
        switch context.transitionStyle {
        case .Modal:
            
            if let sourceModalTransitionStyle = UIModalTransitionStyle(rawValue: sourceModalTransitionStyle.rawValue) {
                context.navigationController.modalTransitionStyle = sourceModalTransitionStyle
            }
            
            if let sourceModalPresentationStyle = UIModalPresentationStyle(rawValue: sourceModalPresentationStyle.rawValue) {
                context.navigationController.modalPresentationStyle = sourceModalPresentationStyle
            }
            
            if let targetModalTransitionStyle = UIModalTransitionStyle(rawValue: targetModalTransitionStyle.rawValue) {
                context.targetViewController.modalTransitionStyle = targetModalTransitionStyle
            }
            
            if let targetModalPresentationStyle = UIModalPresentationStyle(rawValue: targetModalPresentationStyle.rawValue) {
                context.targetViewController.modalPresentationStyle = targetModalPresentationStyle
            }
            
        default:
            break
        }
        
        super.animatePerformingTransition(animationContext: context)
    }
}