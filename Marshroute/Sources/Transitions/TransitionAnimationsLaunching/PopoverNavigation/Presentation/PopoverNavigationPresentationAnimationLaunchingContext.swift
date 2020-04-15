import UIKit

/// Описание параметров запуска анимаций показа UIPopoverController'а, содержащего UINavigationController
public struct PopoverNavigationPresentationAnimationLaunchingContext {
    /// стиль перехода
    public let transitionStyle: PopoverTransitionStyle
    
    /// контроллер, лежащий в поповере, который нужно показать
    public private(set) weak var targetViewController: UIViewController?
    
    /// контроллер, лежащий в поповере, который нужно показать
    public private(set) weak var targetNavigationController: UINavigationController?
    
    // поповер, который нужно показать
    public private(set) weak var popoverController: UIPopoverController?
    
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
    
    public var isDescribingScreenThatWasAlreadyDismissedWithoutInvokingMarshroute: Bool
    {
        if targetViewController == nil {
            return true
        }
        
        if popoverController?.isPopoverVisible != true { 
            marshrouteAssertionFailure(
                """
                It looks like \(targetViewController as Any) did not deallocate due to some retain cycle! 
                """
            )
            return true
        }
        
        return false
    }
}
