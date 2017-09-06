import UIKit

/// Описание параметров анимаций прямого модального перехода на UISplitViewController
public struct ModalMasterDetailPresentationAnimationContext {
    /// контроллер, на который нужно осуществить прямой модальный переход
    public let targetViewController: UISplitViewController
    
    /// контроллер, с которого нужно осуществить прямой модальный переход
    public let sourceViewController: UIViewController
    
    public init(
        targetViewController: UISplitViewController,
        sourceViewController: UIViewController)
    {
        self.targetViewController = targetViewController
        self.sourceViewController = sourceViewController
    }
    
    public init?(
        modalMasterDetailPresentationAnimationLaunchingContext: ModalMasterDetailPresentationAnimationLaunchingContext)
    {
        guard let targetViewController = modalMasterDetailPresentationAnimationLaunchingContext.targetViewController
            else { return nil }
        
        guard let sourceViewController = modalMasterDetailPresentationAnimationLaunchingContext.sourceViewController
            else { return nil }
        
        self.targetViewController = targetViewController
        self.sourceViewController = sourceViewController
    }
}
