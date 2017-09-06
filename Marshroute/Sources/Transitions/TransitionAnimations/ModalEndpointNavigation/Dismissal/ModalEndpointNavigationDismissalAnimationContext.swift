import UIKit

/// Описание параметров анимаций обратного модального перехода c конечного UINavigationController'а,
/// например, с MFMailComposeViewController'а, UIImagePickerController'а
public struct ModalEndpointNavigationDismissalAnimationContext {
    /// контроллер, на который нужно осуществить обратный модальный переход
    public let targetViewController: UIViewController
    
    /// навигационный контроллер, с которого нужно осуществить обратный модальный переход
    public let sourceNavigationController: UINavigationController
    
    public init(
        targetViewController: UIViewController,
        sourceNavigationController: UINavigationController)
    {
        self.targetViewController = targetViewController
        self.sourceNavigationController = sourceNavigationController
    }
    
    public init(
        modalEndpointNavigationDismissalAnimationLaunchingContext animationLaunchingContext: ModalEndpointNavigationDismissalAnimationLaunchingContext)
    {
        self.targetViewController = animationLaunchingContext.targetViewController
        self.sourceNavigationController = animationLaunchingContext.sourceNavigationController
    }
}
