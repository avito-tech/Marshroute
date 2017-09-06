import UIKit

/// Описание параметров запуска pop-анимаций с участием UINavigationController
public struct PopAnimationLaunchingContext {
    /// контроллер, на который нужно осуществить pop-переход
    public let targetViewController: UIViewController
    
    /// контроллер, с навигационного контроллера которого нужно осуществить обратный модальный переход
    public let sourceViewController: UIViewController
    
    // навигационный контроллер, осуществляющий push-переход
    public let navigationController: UINavigationController
    
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
    
    public init?(
        pushAnimationLaunchingContext: PushAnimationLaunchingContext,
        targetViewController: UIViewController)
    {
        guard let sourceViewController = pushAnimationLaunchingContext.targetViewController
            else { return nil }
        
        guard let navigationController = pushAnimationLaunchingContext.navigationController
            else { return nil }
        
        self.targetViewController = targetViewController
        self.sourceViewController = sourceViewController
        self.navigationController = navigationController
        self.animator = pushAnimationLaunchingContext.animator
    }
}
