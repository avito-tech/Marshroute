import UIKit

/// Описание параметров запуска анимаций сокрытия UIPopoverController'а, содержащего UINavigationViewController
public struct PopoverNavigationDismissalAnimationLaunchingContext {
    /// стиль перехода
    public let transitionStyle: PopoverTransitionStyle
    
    /// контроллер, под которым лежит поповер
    public let targetViewController: UIViewController
    
    /// контроллер, лежащий в навигационном контроллере, который лежит в поповере
    public let sourceViewController: UIViewController
    
    /// навигационный контроллер, лежащий в поповере
    public let sourceNavigationController: UINavigationController
    
    // поповер, который нужно сокрыть
    public let popoverController: UIPopoverController
    
    /// аниматор, выполняющий анимации прямого и обратного перехода
    public let animator: PopoverNavigationTransitionsAnimator
    
    public init(
        transitionStyle: PopoverTransitionStyle,
        targetViewController: UIViewController,
        sourceViewController: UIViewController,
        sourceNavigationController: UINavigationController,
        popoverController: UIPopoverController,
        animator: PopoverNavigationTransitionsAnimator)
    {
        self.transitionStyle = transitionStyle
        self.targetViewController = targetViewController
        self.sourceViewController = sourceViewController
        self.sourceNavigationController = sourceNavigationController
        self.popoverController = popoverController
        self.animator = animator
    }
    
    public init?(
        popoverNavigationPresentationAnimationLaunchingContext: PopoverNavigationPresentationAnimationLaunchingContext,
        targetViewController: UIViewController)
    {
        guard let sourceViewController = popoverNavigationPresentationAnimationLaunchingContext.targetViewController
            else { return nil }
        
        guard let sourceNavigationController = popoverNavigationPresentationAnimationLaunchingContext.targetNavigationController
            else { return nil }
        
        guard let popoverController = popoverNavigationPresentationAnimationLaunchingContext.popoverController
            else { return nil }
        
        self.transitionStyle = popoverNavigationPresentationAnimationLaunchingContext.transitionStyle
        self.targetViewController = targetViewController
        self.sourceViewController = sourceViewController
        self.sourceNavigationController = sourceNavigationController
        self.popoverController = popoverController
        self.animator = popoverNavigationPresentationAnimationLaunchingContext.animator
    }
}
