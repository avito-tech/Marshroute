import UIKit

/// Описание параметров анимаций обратного модального перехода c UISplitViewController'а
public struct ModalMasterDetailDismissalAnimationContext {
    /// контроллер, на который нужно осуществить обратный модальный переход
    public let targetViewController: UIViewController
    
    /// контроллер, с которого нужно осуществить обратный модальный переход
    public let sourceViewController: SplitViewControllerProtocol & UIViewController
    
    public init(
        targetViewController: UIViewController,
        sourceViewController: SplitViewControllerProtocol & UIViewController)
    {
        self.targetViewController = targetViewController
        self.sourceViewController = sourceViewController
    }
    
    public init(
        modalMasterDetailDismissalAnimationLaunchingContext: ModalMasterDetailDismissalAnimationLaunchingContext)
    {
        self.targetViewController = modalMasterDetailDismissalAnimationLaunchingContext.targetViewController
        self.sourceViewController = modalMasterDetailDismissalAnimationLaunchingContext.sourceViewController
    }
}
