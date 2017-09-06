import UIKit

/// Описание параметров анимаций прямого модального перехода на конечный UINavigationController,
/// например, на MFMailComposeViewController, UIImagePickerController
public struct ModalEndpointNavigationPresentationAnimationContext {
    /// навигационный контроллер, на который нужно осуществить прямой модальный переход
    public let targetNavigationController: UINavigationController
    
    /// контроллер, с которого нужно осуществить прямой модальный переход
    public let sourceViewController: UIViewController
    
    public init(
        targetNavigationController: UINavigationController,
        sourceViewController: UIViewController)
    {
        self.targetNavigationController = targetNavigationController
        self.sourceViewController = sourceViewController
    }
    
    public init?(
        modalEndpointNavigationPresentationAnimationLaunchingContext animationLaunchingContext: ModalEndpointNavigationPresentationAnimationLaunchingContext)
    {
        guard let targetNavigationController = animationLaunchingContext.targetNavigationController
            else { return nil }
        
        guard let sourceViewController = animationLaunchingContext.sourceViewController
            else { return nil }
        
        self.targetNavigationController = targetNavigationController
        self.sourceViewController = sourceViewController
    }
}
