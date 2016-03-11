import UIKit

/// Параметры анимации переходов с участием UIPopoverController,
/// получаемые из информации о конечной точке прямого или обратного перехода
public struct PopoverAnimationTargetParameters {
    public private(set) weak var viewController: UIViewController?
    
    public init(viewController: UIViewController)
    {
        self.viewController = viewController
    }
}