import UIKit

/// Описание параметров запуска reset-анимаций с участием UINavigationController
public struct ResettingAnimationLaunchingContext {
    /// контроллер, который нужно вставить в `UINavigationController`
    public private(set) weak var targetViewController: UIViewController?
    
    /// аниматор, выполняющий анимации прямого и обратного перехода
    public let animator: ResetTransitionsAnimator
    
    public init(
        targetViewController: UIViewController,
        animator: ResetTransitionsAnimator)
    {
        self.targetViewController = targetViewController
        self.animator = animator
    }
    
    // навигационный контроллер, осуществляющий reset-переход
    public weak var navigationController: UINavigationController?
}