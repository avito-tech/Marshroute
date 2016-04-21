import UIKit

/// Описание параметров запуска reset-анимаций с участием UINavigationController
public struct ResettingAnimationContext {
    /// контроллер, который нужно вставить в `UINavigationController`
    public let targetViewController: UIViewController
    
    // навигационный контроллер, осуществляющий reset-переход
    public let navigationController: UINavigationController
    
    public init(
        targetViewController: UIViewController,
        navigationController: UINavigationController)
    {
        self.targetViewController = targetViewController
        self.navigationController = navigationController
    }
}