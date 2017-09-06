import UIKit

/// Описание параметров pop анимаций с участием UINavigationController
public struct PopAnimationContext {
    /// контроллер, на который нужно осуществить pop-переход
    public let targetViewController: UIViewController
    
    /// контроллер, с которого нужно осуществить pop-переход
    public let sourceViewController: UIViewController
    
    // навигационный контроллер, осуществляющий pop-переход
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
    
    public init(
        popAnimationLaunchingContext: PopAnimationLaunchingContext)
    {
        self.targetViewController = popAnimationLaunchingContext.targetViewController
        self.sourceViewController = popAnimationLaunchingContext.sourceViewController
        self.navigationController = popAnimationLaunchingContext.navigationController
    }
}
