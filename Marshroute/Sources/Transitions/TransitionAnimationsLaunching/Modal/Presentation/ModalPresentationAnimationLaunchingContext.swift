import UIKit

/// Описание параметров запуска анимаций прямого модального перехода на UIViewController
public struct ModalPresentationAnimationLaunchingContext {
    /// контроллер, на который нужно осуществить модальный переход
    public fileprivate(set) weak var targetViewController: UIViewController?
    
    /// аниматор, выполняющий анимации прямого и обратного перехода
    public let animator: ModalTransitionsAnimator
    
    public init(
        targetViewController: UIViewController,
        animator: ModalTransitionsAnimator)
    {
        self.targetViewController = targetViewController
        self.animator = animator
    }
    
    // контроллер, с которого нужно осуществить модальный переход
    public weak var sourceViewController: UIViewController?
}
