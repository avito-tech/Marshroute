import UIKit

/// Описание параметров запуска reset-анимаций с участием UINavigationController
public struct ResettingAnimationLaunchingContext {
    /// контроллер, который нужно вставить в `UINavigationController`
    public private(set) weak var rootViewController: UIViewController?
    
    /// аниматор, выполняющий анимации прямого и обратного перехода
    public let animator: ResetTransitionsAnimatorImpl
    
    public init(
        rootViewController: UIViewController,
        animator: ResetTransitionsAnimatorImpl)
    {
        self.rootViewController = rootViewController
        self.animator = animator
    }
    
    // навигационный контроллер, осуществляющий reset-переход
    public weak var navigationController: UINavigationController?
}