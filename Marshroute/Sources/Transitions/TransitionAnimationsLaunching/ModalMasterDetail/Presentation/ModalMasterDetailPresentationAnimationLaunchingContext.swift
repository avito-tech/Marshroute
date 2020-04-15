import UIKit

/// Описание параметров запуска анимаций прямого модального перехода на UISplitViewController
public struct ModalMasterDetailPresentationAnimationLaunchingContext {
    /// контроллер, на который нужно осуществить модальный переход
    public private(set) weak var targetViewController: UISplitViewController?
    
    /// аниматор, выполняющий анимации прямого и обратного перехода
    public let animator: ModalMasterDetailTransitionsAnimator
    
    public init(
        targetViewController: UISplitViewController,
        animator: ModalMasterDetailTransitionsAnimator)
    {
        self.targetViewController = targetViewController
        self.animator = animator
    }
    
    // контроллер, с которого нужно осуществить модальный переход
    public weak var sourceViewController: UIViewController?
    
    public var isDescribingScreenThatWasAlreadyDismissedWithoutInvokingMarshroute: Bool
    {
        if targetViewController == nil {
            return true
        }
        
        if sourceViewController?.presentedViewController == nil {
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
