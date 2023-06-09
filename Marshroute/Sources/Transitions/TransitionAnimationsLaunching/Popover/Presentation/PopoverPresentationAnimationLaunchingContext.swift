import UIKit

/// Описание параметров запуска анимаций показа UIPopoverController'а, содержащего UIViewController
public struct PopoverPresentationAnimationLaunchingContext {
    /// стиль перехода
    public let transitionStyle: PopoverTransitionStyle
    
    /// контроллер, лежащий в поповере, который нужно показать
    public private(set) weak var targetViewController: UIViewController?
    
    // поповер, который нужно показать
    public private(set) weak var popoverController: UIPopoverController?
    
    /// аниматор, выполняющий анимации прямого и обратного перехода
    public let animator: PopoverTransitionsAnimator
    
    public init(
        transitionStyle: PopoverTransitionStyle,
        targetViewController: UIViewController,
        popoverController: UIPopoverController,
        animator: PopoverTransitionsAnimator)
    {
        self.transitionStyle = transitionStyle
        self.targetViewController = targetViewController
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
            assertPossibleRetainCycle(ofViewController: targetViewController)
            return true
        }
        
        return false
    }
}
