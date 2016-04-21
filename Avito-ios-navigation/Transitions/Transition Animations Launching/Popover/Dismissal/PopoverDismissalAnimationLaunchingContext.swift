import UIKit

/// Описание параметров запуска анимаций сокрытия UIPopoverController'а, содержащего UIViewController
public struct PopoverDismissalAnimationLaunchingContext {
    /// стиль перехода
    public let transitionStyle: PopoverTransitionStyle
    
    /// контроллер, под которым лежит поповер
    public private(set) weak var targetViewController: UIViewController?
    
    /// контроллер, лежащий в поповере
    public private(set) weak var sourceViewController: UIViewController?
    
    // поповер, котороый нужно сокрыть
    public private(set) weak var popoverController: UIPopoverController?
    
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
}