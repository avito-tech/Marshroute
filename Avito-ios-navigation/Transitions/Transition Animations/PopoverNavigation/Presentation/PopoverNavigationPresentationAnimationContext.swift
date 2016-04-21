import UIKit

/// Описание параметров анимаций показа UIPopoverController'а, содержащего UINavigationController
public struct PopoverNavigationPresentationAnimationContext {
    /// стиль перехода
    public let transitionStyle: PopoverTransitionStyle
    
    /// контроллер, лежащий в навигационном контроллере, который нужно показать в поповере
    public let targetViewController: UIViewController
    
    /// навигационный контроллер, который нужно показать в поповере
    public let targetNavigationController: UINavigationController
    
    /// контроллер, над которым нужно показать поповер
    public let sourceViewController: UIViewController
    
    // поповер, котороый нужно показать
    public let popoverController: UIPopoverController
    
    public init(
        transitionStyle: PopoverTransitionStyle,
        targetViewController: UIViewController,
        targetNavigationController: UINavigationController,
        sourceViewController: UIViewController,
        popoverController: UIPopoverController)
    {
        self.transitionStyle = transitionStyle
        self.targetViewController = targetViewController
        self.targetNavigationController = targetNavigationController
        self.sourceViewController = sourceViewController
        self.popoverController = popoverController
    }
}