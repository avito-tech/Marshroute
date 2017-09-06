import UIKit

/// Описание параметров reset-анимаций
/// для замены корневого контроллера в UINavigationController
public struct ResettingNavigationAnimationContext {
    /// контроллер, который нужно вставить в `UINavigationController`
    public let rootViewController: UIViewController
    
    /// текущий верхний контроллер UINavigationController'а
    public let sourceViewController: UIViewController
    
    // навигационный контроллер, осуществляющий reset-переход
    public let navigationController: UINavigationController
    
    public init(
        rootViewController: UIViewController,
        sourceViewController: UIViewController,
        navigationController: UINavigationController)
    {
        self.rootViewController = rootViewController
        self.sourceViewController = sourceViewController
        self.navigationController = navigationController
    }
    
    public init?(
        resettingAnimationLaunchingContext: ResettingAnimationLaunchingContext)
    {
        guard let rootViewController = resettingAnimationLaunchingContext.rootViewController
            else { return nil }
        
        guard let sourceViewController = resettingAnimationLaunchingContext.sourceViewController
            else { return nil }
        
        guard let navigationController = resettingAnimationLaunchingContext.navigationController
            else { return nil }
        
        self.rootViewController = rootViewController
        self.sourceViewController = sourceViewController
        self.navigationController = navigationController
    }
}
