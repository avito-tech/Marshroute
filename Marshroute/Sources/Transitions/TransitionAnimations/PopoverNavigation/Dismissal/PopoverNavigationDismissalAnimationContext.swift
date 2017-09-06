import UIKit

/// Описание параметров анимаций сокрытия UIPopoverController'а, содержащего UINavigationController
public struct PopoverNavigationDismissalAnimationContext {
    /// стиль перехода
    public let transitionStyle: PopoverTransitionStyle
    
    /// контроллер, над которым нужно сокрыть поповер
    public let targetViewController: UIViewController
    
    /// контроллер, лежащий в навигационном контроллере, который лежит в поповере
    public let sourceViewController: UIViewController
    
    /// навигационный контроллер, который лежит в поповере
    public let sourceNavigationController: UINavigationController
    
    // поповер, который нужно сокрыть
    public let popoverController: UIPopoverController
    
    public init(
        transitionStyle: PopoverTransitionStyle,
        targetViewController: UIViewController,
        sourceViewController: UIViewController,
        sourceNavigationController: UINavigationController,
        popoverController: UIPopoverController)
    {
        self.transitionStyle = transitionStyle
        self.targetViewController = targetViewController
        self.sourceViewController = sourceViewController
        self.sourceNavigationController = sourceNavigationController
        self.popoverController = popoverController
    }
    
    public init(
        popoverNavigationDismissalAnimationLaunchingContext: PopoverNavigationDismissalAnimationLaunchingContext)
    {
        self.transitionStyle = popoverNavigationDismissalAnimationLaunchingContext.transitionStyle
        self.targetViewController = popoverNavigationDismissalAnimationLaunchingContext.targetViewController
        self.sourceViewController = popoverNavigationDismissalAnimationLaunchingContext.sourceViewController
        self.sourceNavigationController = popoverNavigationDismissalAnimationLaunchingContext.sourceNavigationController
        self.popoverController = popoverNavigationDismissalAnimationLaunchingContext.popoverController
    }
}
