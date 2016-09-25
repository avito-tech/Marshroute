import UIKit

/// Описание параметров запуска reset-анимаций 
/// для перевыставления корневого контроллера в UINavigationController
public struct ResettingAnimationLaunchingContext {
    /// контроллер, который нужно вставить в `UINavigationController`
    public fileprivate(set) weak var rootViewController: UIViewController?
    
    /// аниматор, выполняющий reset-анимации
    public let animator: ResetNavigationTransitionsAnimator
    
    public init(
        rootViewController: UIViewController,
        animator: ResetNavigationTransitionsAnimator)
    {
        self.rootViewController = rootViewController
        self.animator = animator
    }
    
    // навигационный контроллер, осуществляющий reset-переход
    public weak var navigationController: UINavigationController?
    
    /// текущий верхний контроллер UINavigationController'а
    public weak var sourceViewController: UIViewController?
}
