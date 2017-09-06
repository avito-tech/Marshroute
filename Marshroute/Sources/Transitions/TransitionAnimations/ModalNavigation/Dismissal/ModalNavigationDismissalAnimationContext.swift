import UIKit

/// Описание параметров анимаций обратного модального перехода c UINavigationController'а
public struct ModalNavigationDismissalAnimationContext {
    /// контроллер, на который нужно осуществить обратный модальный переход
    public let targetViewController: UIViewController
    
    /// контроллер, с которого нужно осуществить обратный модальный переход
    public let sourceViewController: UIViewController
    
    /// навигационный контроллер, с которого нужно осуществить обратный модальный переход
    public let sourceNavigationController: UINavigationController
    
    public init(
        targetViewController: UIViewController,
        sourceViewController: UIViewController,
        sourceNavigationController: UINavigationController)
    {
        self.targetViewController = targetViewController
        self.sourceViewController = sourceViewController
        self.sourceNavigationController = sourceNavigationController
    }
    
    public init(
        modalNavigationDismissalAnimationLaunchingContext: ModalNavigationDismissalAnimationLaunchingContext)
    {
        self.targetViewController = modalNavigationDismissalAnimationLaunchingContext.targetViewController
        self.sourceViewController = modalNavigationDismissalAnimationLaunchingContext.sourceViewController
        self.sourceNavigationController = modalNavigationDismissalAnimationLaunchingContext.sourceNavigationController
    }
}
