import UIKit

/// Описание параметров запуска reset-анимаций с участием UINavigationController
public struct ResettingAnimationContext {
    /// контроллер, который нужно вставить в `UINavigationController`
    public let rootViewController: UIViewController
    
    // навигационный контроллер, осуществляющий reset-переход
    public let navigationController: UINavigationController
    
    public init(
        rootViewController: UIViewController,
        navigationController: UINavigationController)
    {
        self.rootViewController = rootViewController
        self.navigationController = navigationController
    }
    
    public init?(
        resettingAnimationLaunchingContext: ResettingAnimationLaunchingContext)
    {
        guard let rootViewController = resettingAnimationLaunchingContext.rootViewController
            else { return nil }
        
        guard let navigationController = resettingAnimationLaunchingContext.navigationController
            else { return nil }
        
        self.rootViewController = rootViewController
        self.navigationController = navigationController
    }
}