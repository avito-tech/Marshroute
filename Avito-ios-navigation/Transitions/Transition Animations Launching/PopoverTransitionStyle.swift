import UIKit

/// Стили переходов с участием UIPopoverController
public enum PopoverTransitionStyle {
    case PopoverFromView(
        sourceView: UIView,
        sourceRect: CGRect
    )
    
    case PopoverFromBarButtonItem(
        buttonItem: UIBarButtonItem
    )
}