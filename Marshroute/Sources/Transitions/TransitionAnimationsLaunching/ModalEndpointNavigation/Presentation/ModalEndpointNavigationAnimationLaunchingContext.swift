import UIKit

/// Описание параметров запуска анимаций прямого модального перехода на конечный UINavigationController,
/// например, MFMailComposeViewController, UIImagePickerController
public struct ModalEndpointNavigationPresentationAnimationLaunchingContext {
    /// навигационный контроллер, на который нужно осуществить модальный переход
    public fileprivate(set) weak var targetNavigationController: UINavigationController?
    
    /// аниматор, выполняющий анимации прямого и обратного перехода
    public let animator: ModalEndpointNavigationTransitionsAnimator
    
    public init(
        targetNavigationController: UINavigationController,
        animator: ModalEndpointNavigationTransitionsAnimator)
    {
        self.targetNavigationController = targetNavigationController
        self.animator = animator
    }
    
    // контроллер, с которого нужно осуществить модальный переход
    public weak var sourceViewController: UIViewController?
}
