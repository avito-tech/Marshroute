import UIKit

/// Описание параметров запуска анимаций обратного модального перехода с UIViewController'а
public struct ModalDismissalAnimationLaunchingContext {
    /// контроллер, на который нужно осуществить обратный модальный переход
    public let targetViewController: UIViewController
    
    /// контроллер, с которого нужно осуществить обратный модальный переход
    public let sourceViewController: UIViewController
    
    /// аниматор, выполняющий анимации прямого и обратного перехода
    public let animator: ModalTransitionsAnimator
    
    public init(
        targetViewController: UIViewController,
        sourceViewController: UIViewController,
        animator: ModalTransitionsAnimator)
    {
        self.targetViewController = targetViewController
        self.sourceViewController = sourceViewController
        self.animator = animator
    }
    
    public init?(
        modalPresentationAnimationLaunchingContext: ModalPresentationAnimationLaunchingContext,
        targetViewController: UIViewController)
    {
        guard let sourceViewController = modalPresentationAnimationLaunchingContext.targetViewController
            else { return nil }
        
        self.targetViewController = targetViewController
        self.sourceViewController = sourceViewController
        self.animator = modalPresentationAnimationLaunchingContext.animator
    }
}
