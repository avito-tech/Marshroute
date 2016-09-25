import UIKit

/// Описание параметров запуска анимаций прямого модального перехода на UINavigationController
public struct ModalNavigationPresentationAnimationLaunchingContext {
    /// навигационный контроллер, на который нужно осуществить модальный переход
    public fileprivate(set) weak var targetNavigationController: UINavigationController?
    
    /// контроллер, на навигационный контроллер которого нужно осуществить модальный переход
    public fileprivate(set) weak var targetViewController: UIViewController?
    
    /// аниматор, выполняющий анимации прямого и обратного перехода
    public let animator: ModalNavigationTransitionsAnimator
    
    public init(
        targetNavigationController: UINavigationController,
        targetViewController: UIViewController,
        animator: ModalNavigationTransitionsAnimator)
    {
        self.targetNavigationController = targetNavigationController
        self.targetViewController = targetViewController
        self.animator = animator
    }
    
    // контроллер, с которого нужно осуществить модальный переход
    public weak var sourceViewController: UIViewController?
}
