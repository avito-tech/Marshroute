import UIKit

/// Параметры анимации переходов с участием UINavigationController,
/// получаемые из информации о конечной точке прямого или обратного перехода
public struct NavigationAnimationTargetParameters {
    public private(set) weak var viewController: UIViewController?
    
    public init(viewController: UIViewController)
    {
        self.viewController = viewController
    }
}