import UIKit

/// Описание параметров запуска анимаций сокрытия UIPopoverController'а, содержащего UIViewController
public struct PopoverDismissalAnimationLaunchingContext {
    /// стиль перехода
    public let transitionStyle: PopoverTransitionStyle
    
    /// контроллер, под которым лежит поповер
    public let targetViewController: UIViewController
    
    /// контроллер, лежащий в поповере
    public let sourceViewController: UIViewController
    
    // поповер, который нужно сокрыть
    public let popoverController: UIPopoverController
    
    /// аниматор, выполняющий анимации прямого и обратного перехода
    public let animator: PopoverTransitionsAnimator
    
    public init(
        transitionStyle: PopoverTransitionStyle,
        targetViewController: UIViewController,
        sourceViewController: UIViewController,
        popoverController: UIPopoverController,
        animator: PopoverTransitionsAnimator)
    {
        self.transitionStyle = transitionStyle
        self.targetViewController = targetViewController
        self.sourceViewController = sourceViewController
        self.popoverController = popoverController
        self.animator = animator
    }
    
    public init?(
        popoverPresentationAnimationLaunchingContext: PopoverPresentationAnimationLaunchingContext,
        targetViewController: UIViewController)
    {
        guard let sourceViewController = popoverPresentationAnimationLaunchingContext.targetViewController
            else { return nil }
        
        guard let popoverController = popoverPresentationAnimationLaunchingContext.popoverController
            else { return nil }
        
        self.transitionStyle = popoverPresentationAnimationLaunchingContext.transitionStyle
        self.targetViewController = targetViewController
        self.sourceViewController = sourceViewController
        self.popoverController = popoverController
        self.animator = popoverPresentationAnimationLaunchingContext.animator
    }
}
