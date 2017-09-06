import UIKit

/// Описание параметров push анимаций с участием UINavigationController
public struct PushAnimationContext {
    /// контроллер, на который нужно осуществить push-переход
    public let targetViewController: UIViewController
    
    /// контроллер, с которого нужно осуществить push-переход
    public let sourceViewController: UIViewController
    
    // навигационный контроллер, осуществляющий push-переход
    public let navigationController: UINavigationController
    
    public init(
        targetViewController: UIViewController,
        sourceViewController: UIViewController,
        navigationController: UINavigationController)
    {
        self.targetViewController = targetViewController
        self.sourceViewController = sourceViewController
        self.navigationController = navigationController
    }
    
    public init?(
        pushAnimationLaunchingContext: PushAnimationLaunchingContext)
    {
        guard let targetViewController = pushAnimationLaunchingContext.targetViewController
            else { return nil }
        
        guard let sourceViewController = pushAnimationLaunchingContext.sourceViewController
            else { return nil }
        
        guard let navigationController = pushAnimationLaunchingContext.navigationController
            else { return nil }
        
        self.targetViewController = targetViewController
        self.sourceViewController = sourceViewController
        self.navigationController = navigationController
    }
}
