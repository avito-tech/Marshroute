import UIKit

/// Описание параметров анимаций показа UIPopoverController'а, содержащего UIViewController
public struct PopoverPresentationAnimationContext {
    /// стиль перехода
    public let transitionStyle: PopoverTransitionStyle
    
    /// контроллер, который нужно показать в поповере
    public let targetViewController: UIViewController
    
    /// контроллер, над которым нужно показать поповер
    public let sourceViewController: UIViewController
    
    // поповер, который нужно показать
    public let popoverController: UIPopoverController
    
    public init(
        transitionStyle: PopoverTransitionStyle,
        targetViewController: UIViewController,
        sourceViewController: UIViewController,
        popoverController: UIPopoverController)
    {
        self.transitionStyle = transitionStyle
        self.targetViewController = targetViewController
        self.sourceViewController = sourceViewController
        self.popoverController = popoverController
    }
    
    public init?(
        popoverPresentationAnimationLaunchingContext: PopoverPresentationAnimationLaunchingContext)
    {
        guard let targetViewController = popoverPresentationAnimationLaunchingContext.targetViewController
            else { return nil }
        
        guard let sourceViewController = popoverPresentationAnimationLaunchingContext.sourceViewController
            else { return nil }
        
        guard let popoverController = popoverPresentationAnimationLaunchingContext.popoverController
            else { return nil }
        
        self.transitionStyle = popoverPresentationAnimationLaunchingContext.transitionStyle
        self.targetViewController = targetViewController
        self.sourceViewController = sourceViewController
        self.popoverController = popoverController
    }
}
