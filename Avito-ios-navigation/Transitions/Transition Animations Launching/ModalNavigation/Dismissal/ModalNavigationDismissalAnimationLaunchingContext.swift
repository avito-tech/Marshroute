import UIKit

/// Описание параметров запуска анимаций обратного модального перехода с UINavigationController'а
public struct ModalNavigationDismissalAnimationLaunchingContext {
    /// контроллер, на который нужно осуществить обратный модальный переход
    public private(set) weak var targetViewController: UIViewController?
    
    /// контроллер, с навигационного контроллера которого нужно осуществить обратный модальный переход
    public private(set) weak var sourceViewController: UIViewController?
    
    /// навигационный контроллер, с которого нужно осуществить обратный модальный переход
    public private(set) weak var sourceNavigationController: UINavigationController?
    
    /// аниматор, выполняющий анимации прямого и обратного перехода
    public let animator: ModalNavigationTransitionsAnimator
    
    public init(
        targetViewController: UIViewController,
        sourceViewController: UIViewController,
        sourceNavigationController: UINavigationController,
        animator: ModalNavigationTransitionsAnimator)
    {
        self.targetViewController = targetViewController
        self.sourceViewController = sourceViewController
        self.sourceNavigationController = sourceNavigationController
        self.animator = animator
    }
}