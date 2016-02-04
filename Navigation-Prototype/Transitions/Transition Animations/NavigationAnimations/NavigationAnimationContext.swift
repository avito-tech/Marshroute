import UIKit

struct NavigationAnimationContext: TransitionAnimationContext {
    /// контроллер навигации, выполняющий push/pop или presentModal
    let navigationController: UINavigationController
    
    /// контроллер, куда осуществляется прямой или обратный переход
    let targetViewController: UIViewController
    
    let animationStyle: NavigationAnimationStyle
}