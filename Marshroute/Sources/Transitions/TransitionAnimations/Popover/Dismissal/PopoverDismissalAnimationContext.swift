import UIKit

/// Описание параметров анимаций сокрытия UIPopoverController'а, содержащего UIViewController
public struct PopoverDismissalAnimationContext {
    /// стиль перехода
    public let transitionStyle: PopoverTransitionStyle
    
    /// контроллер, над которым нужно сокрыть поповер
    public let targetViewController: UIViewController
    
    /// контроллер, который лежит в поповере
    public let sourceViewController: UIViewController
    
    // поповер, который нужно сокрыть
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
    
    public init(
        popoverDismissalAnimationLaunchingContext: PopoverDismissalAnimationLaunchingContext)
    {
        self.transitionStyle = popoverDismissalAnimationLaunchingContext.transitionStyle
        self.targetViewController = popoverDismissalAnimationLaunchingContext.targetViewController
        self.sourceViewController = popoverDismissalAnimationLaunchingContext.sourceViewController
        self.popoverController = popoverDismissalAnimationLaunchingContext.popoverController
    }
}
