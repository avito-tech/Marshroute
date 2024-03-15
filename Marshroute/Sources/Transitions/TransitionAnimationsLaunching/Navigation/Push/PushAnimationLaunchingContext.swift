import UIKit

/// Описание параметров запуска анимаций push-перехода на UIViewController
public struct PushAnimationLaunchingContext {
    /// контроллер, на который нужно осуществить push-переход
    public private(set) weak var targetViewController: UIViewController?

    /// аниматор, выполняющий анимации прямого и обратного перехода
    public let animator: NavigationTransitionsAnimator
    
    public init(
        targetViewController: UIViewController,
        animator: NavigationTransitionsAnimator)
    {
        self.targetViewController = targetViewController
        self.animator = animator
    }
    
    // навигационный контроллер, осуществляющий push-переход
    public weak var navigationController: UINavigationController?
    
    // контроллер, с которого нужно осуществить push-переход
    public weak var sourceViewController: UIViewController?
    
    public var isDescribingScreenThatWasAlreadyDismissedWithoutInvokingMarshroute: Bool
    {
        if targetViewController == nil {
            return true
        }
        
        if let navigationController = navigationController,
            let targetViewController = targetViewController,
            !navigationController.viewControllers.contains(targetViewController)
        {
            assertPossibleRetainCycle(for: targetViewController)
            return true
        }
        
        return false
    }
}
