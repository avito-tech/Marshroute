import UIKit

/// Описание параметров запуска анимаций обратного модального перехода с UISplitViewController'а
public struct ModalMasterDetailDismissalAnimationLaunchingContext {
    /// контроллер, на который нужно осуществить обратный модальный переход
    public let targetViewController: UIViewController
    
    /// контроллер, с которого нужно осуществить обратный модальный переход
    public let sourceViewController: UISplitViewController
    
    /// аниматор, выполняющий анимации прямого и обратного перехода
    public let animator: ModalMasterDetailTransitionsAnimator
    
    public init(
        targetViewController: UIViewController,
        sourceViewController: UISplitViewController,
        animator: ModalMasterDetailTransitionsAnimator)
    {
        self.targetViewController = targetViewController
        self.sourceViewController = sourceViewController
        self.animator = animator
    }
    
    public init?(
        modalPresentationAnimationLaunchingContext: ModalMasterDetailPresentationAnimationLaunchingContext,
        targetViewController: UIViewController)
    {
        guard let sourceViewController = modalPresentationAnimationLaunchingContext.targetViewController
            else { return nil }
        
        self.targetViewController = targetViewController
        self.sourceViewController = sourceViewController
        self.animator = modalPresentationAnimationLaunchingContext.animator
    }
}
