import UIKit

/// Описание параметров set-анимаций
/// для первоначального проставления корневого контроллера в UINavigationController
public struct SettingNavigationAnimationContext {
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
        settingAnimationLaunchingContext: SettingAnimationLaunchingContext)
    {
        guard let rootViewController = settingAnimationLaunchingContext.rootViewController
            else { return nil }
        
        guard let navigationController = settingAnimationLaunchingContext.navigationController
            else { return nil }
        
        self.rootViewController = rootViewController
        self.navigationController = navigationController
    }
}
