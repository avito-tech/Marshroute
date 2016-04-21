import UIKit

/// Описание параметров запуска pop-анимаций с участием UINavigationController
public struct PopAnimationLaunchingContext {
    /// контроллер, на который нужно осуществить pop-переход
    public private(set) weak var targetViewController: UIViewController?
    
    /// контроллер, с навигационного контроллера которого нужно осуществить обратный модальный переход
    public private(set) weak var sourceViewController: UIViewController?
    
    // навигационный контроллер, осуществляющий push-переход
    public private(set) weak var navigationController: UINavigationController?
    
    /// аниматор, выполняющий анимации прямого и обратного перехода
    public let animator: NavigationTransitionsAnimator
    
    public init(
        targetViewController: UIViewController,
        sourceViewController: UIViewController,
        navigationController: UINavigationController,
        animator: NavigationTransitionsAnimator)
    {
        self.targetViewController = targetViewController
        self.sourceViewController = sourceViewController
        self.navigationController = navigationController
        self.animator = animator
    }   
}