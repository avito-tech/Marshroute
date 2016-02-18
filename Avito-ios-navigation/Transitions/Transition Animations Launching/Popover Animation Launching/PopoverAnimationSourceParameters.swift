import UIKit

public struct PopoverAnimationSourceParameters {
    public private (set) weak var popoverController: UIPopoverController?
    
    public init(popoverController: UIPopoverController)
    {
        self.popoverController = popoverController
    }
}