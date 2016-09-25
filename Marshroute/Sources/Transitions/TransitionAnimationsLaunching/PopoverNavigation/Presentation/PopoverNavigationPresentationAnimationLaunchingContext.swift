import UIKit

/// Описание параметров запуска анимаций показа UIPopoverController'а, содержащего UINavigationController
public struct PopoverNavigationPresentationAnimationLaunchingContext {
    /// стиль перехода
    public let transitionStyle: PopoverTransitionStyle
    
    /// контроллер, лежащий в поповере, который нужно показать
    public fileprivate(set) weak var targetViewController: UIViewController?
    
    /// контроллер, лежащий в поповере, который нужно показать
    public fileprivate(set) weak var targetNavigationController: UINavigationController?
    
    // поповер, который нужно показать
    public fileprivate(set) weak var popoverController: UIPopoverController?
    
    /// аниматор, выполняющий анимации прямого и обратного перехода
    public let animator: PopoverNavigationTransitionsAnimator
    
    public init(
        transitionStyle: PopoverTransitionStyle,
        targetViewController: UIViewController,
        targetNavigationController: UINavigationController,
        popoverController: UIPopoverController,
        animator: PopoverNavigationTransitionsAnimator)
    {
        self.transitionStyle = transitionStyle
        self.targetViewController = targetViewController
        self.targetNavigationController = targetNavigationController
        self.popoverController = popoverController
        self.animator = animator
    }
    
    /// контроллер, над которым появится поповер
    public weak var sourceViewController: UIViewController?
}
