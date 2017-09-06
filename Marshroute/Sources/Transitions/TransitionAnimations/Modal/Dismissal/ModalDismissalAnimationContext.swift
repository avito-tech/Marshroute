import UIKit

/// Описание параметров анимаций обратного модального перехода c UIViewController'а
public struct ModalDismissalAnimationContext {
    /// контроллер, на который нужно осуществить обратный модальный переход
    public let targetViewController: UIViewController
    
    /// контроллер, с которого нужно осуществить обратный модальный переход
    public let sourceViewController: UIViewController
    
    public init(
        targetViewController: UIViewController,
        sourceViewController: UIViewController)
    {
        self.targetViewController = targetViewController
        self.sourceViewController = sourceViewController
    }
    
    public init(
        modalDismissalAnimationLaunchingContext: ModalDismissalAnimationLaunchingContext)
    {
        self.targetViewController = modalDismissalAnimationLaunchingContext.targetViewController
        self.sourceViewController = modalDismissalAnimationLaunchingContext.sourceViewController
    }
}
