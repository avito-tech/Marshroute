import UIKit

/// Описание параметров анимаций прямого модального перехода на UINavigationController
public struct ModalNavigationPresentationAnimationContext {
    /// контроллер, на который нужно осуществить прямой модальный переход
    public let targetViewController: UIViewController
    
    /// навигационный контроллер, на который нужно осуществить прямой модальный переход
    public let targetNavigationController: UINavigationController
    
    /// контроллер, с которого нужно осуществить прямой модальный переход
    public let sourceViewController: UIViewController
    
    public init(
        targetViewController: UIViewController,
        targetNavigationController: UINavigationController,
        sourceViewController: UIViewController)
    {
        self.targetViewController = targetViewController
        self.targetNavigationController = targetNavigationController
        self.sourceViewController = sourceViewController
    }
    
    public init?(
        modalNavigationPresentationAnimationLaunchingContext: ModalNavigationPresentationAnimationLaunchingContext)
    {
        guard let targetViewController = modalNavigationPresentationAnimationLaunchingContext.targetViewController
            else { return nil }
        
        guard let targetNavigationController = modalNavigationPresentationAnimationLaunchingContext.targetNavigationController
            else { return nil }
        
        guard let sourceViewController = modalNavigationPresentationAnimationLaunchingContext.sourceViewController
            else { return nil }
        
        self.targetViewController = targetViewController
        self.targetNavigationController = targetNavigationController
        self.sourceViewController = sourceViewController
    }
}
