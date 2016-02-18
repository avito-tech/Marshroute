import UIKit

/// Описание параметров анимаций с участием UIPopoverController
public struct PopoverAnimationContext {
    public let popoverController: UIPopoverController
    public let transitionStyle: PopoverTransitionStyle
    
    public init(
        popoverController: UIPopoverController,
        transitionStyle: PopoverTransitionStyle)
    {
        self.popoverController = popoverController
        self.transitionStyle = transitionStyle
    }
}