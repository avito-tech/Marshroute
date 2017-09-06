import UIKit

/// Описание параметров запуска анимаций обратного модального перехода с конечного UINavigationController'а,
/// например, c MFMailComposeViewController'а, UIImagePickerController'а
public struct ModalEndpointNavigationDismissalAnimationLaunchingContext {
    /// контроллер, на который нужно осуществить обратный модальный переход
    public let targetViewController: UIViewController
    
    /// навигационный контроллер, с которого нужно осуществить обратный модальный переход
    public let sourceNavigationController: UINavigationController
    
    /// аниматор, выполняющий анимации прямого и обратного перехода
    public let animator: ModalEndpointNavigationTransitionsAnimator
    
    public init(
        targetViewController: UIViewController,
        sourceNavigationController: UINavigationController,
        animator: ModalEndpointNavigationTransitionsAnimator)
    {
        self.targetViewController = targetViewController
        self.sourceNavigationController = sourceNavigationController
        self.animator = animator
    }
    
    public init?(
        modalEndpointNavigationPresentationAnimationLaunchingContext presentationAnimationLaunchingContext: ModalEndpointNavigationPresentationAnimationLaunchingContext,
        targetViewController: UIViewController)
    {
        guard let sourceNavigationController = presentationAnimationLaunchingContext.targetNavigationController
            else { return nil }
        
        self.targetViewController = targetViewController
        self.sourceNavigationController = sourceNavigationController
        self.animator = presentationAnimationLaunchingContext.animator
    }
}
