import UIKit

/// Описание параметров запуска анимаций обратного модального перехода с UINavigationController'а
public struct ModalNavigationDismissalAnimationLaunchingContext {
    /// контроллер, на который нужно осуществить обратный модальный переход
    public let targetViewController: UIViewController
    
    /// контроллер, с навигационного контроллера которого нужно осуществить обратный модальный переход
    public let sourceViewController: UIViewController
    
    /// навигационный контроллер, с которого нужно осуществить обратный модальный переход
    public let sourceNavigationController: UINavigationController
    
    /// аниматор, выполняющий анимации прямого и обратного перехода
    public let animator: ModalNavigationTransitionsAnimator
    
    public init(
        targetViewController: UIViewController,
        sourceViewController: UIViewController,
        sourceNavigationController: UINavigationController,
        animator: ModalNavigationTransitionsAnimator)
    {
        self.targetViewController = targetViewController
        self.sourceViewController = sourceViewController
        self.sourceNavigationController = sourceNavigationController
        self.animator = animator
    }
    
    public init?(
        modalNavigationPresentationAnimationLaunchingContext: ModalNavigationPresentationAnimationLaunchingContext,
        targetViewController: UIViewController)
    {
        guard let sourceViewController = modalNavigationPresentationAnimationLaunchingContext.targetViewController
            else { return nil }
        
        guard let sourceNavigationController = modalNavigationPresentationAnimationLaunchingContext.targetNavigationController
            else { return nil }
        
        self.targetViewController = targetViewController
        self.sourceViewController = sourceViewController
        self.sourceNavigationController = sourceNavigationController
        self.animator = modalNavigationPresentationAnimationLaunchingContext.animator
    }
}
