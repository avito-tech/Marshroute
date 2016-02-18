import UIKit

/// Описание параметров анимаций с участием UINavigationController
struct NavigationAnimationContext {
    /// контроллер навигации, выполняющий push/pop или presentModal
    let navigationController: UINavigationController
    
    /// контроллер, куда осуществляется прямой или обратный переход
    let targetViewController: UIViewController
    
    let transitionStyle: NavigationTransitionStyle
}