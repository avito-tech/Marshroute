import UIKit

/// Стили переходов с участием UIPopoverController
enum PopoverTransitionStyle {
    case PopoverFromView(
        sourceView: UIView,
        sourceRect: CGRect
    )
    
    case PopoverFromBarButtonItem(
        buttonItem: UIBarButtonItem
    )
}