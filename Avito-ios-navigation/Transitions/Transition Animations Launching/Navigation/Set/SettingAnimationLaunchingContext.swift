import UIKit

/// Описание параметров запуска reset-анимаций 
/// для первоначально проставления корневого контроллера в UINavigationController
public struct SettingAnimationLaunchingContext {
    /// контроллер, который нужно вставить в `UINavigationController`
    public private(set) weak var rootViewController: UIViewController?
    
    // навигационный контроллер, осуществляющий reset-переход
    public private(set) weak var navigationController: UINavigationController?
    
    /// аниматор, выполняющий reset-анимации
    public let animator: SetNavigationTransitionsAnimator
    
    public init(
        rootViewController: UIViewController,
        navigationController: UINavigationController,
        animator: SetNavigationTransitionsAnimator)
    {
        self.rootViewController = rootViewController
        self.navigationController = navigationController
        self.animator = animator
    }
}