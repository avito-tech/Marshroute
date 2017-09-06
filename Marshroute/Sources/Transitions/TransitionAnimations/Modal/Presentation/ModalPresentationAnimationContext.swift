import UIKit

/// Описание параметров анимаций прямого модального перехода на UIViewController
public struct ModalPresentationAnimationContext {
    /// контроллер, на который нужно осуществить прямой модальный переход
    public let targetViewController: UIViewController
    
    /// контроллер, с которого нужно осуществить прямой модальный переход
    public let sourceViewController: UIViewController
    
    public init(
        targetViewController: UIViewController,
        sourceViewController: UIViewController)
    {
        self.targetViewController = targetViewController
        self.sourceViewController = sourceViewController
    }
    
    public init?(
        modalPresentationAnimationLaunchingContext: ModalPresentationAnimationLaunchingContext)
    {
        guard let targetViewController = modalPresentationAnimationLaunchingContext.targetViewController
            else { return nil }
        
        guard let sourceViewController = modalPresentationAnimationLaunchingContext.sourceViewController
            else { return nil }
        
        self.targetViewController = targetViewController
        self.sourceViewController = sourceViewController
    }
}
