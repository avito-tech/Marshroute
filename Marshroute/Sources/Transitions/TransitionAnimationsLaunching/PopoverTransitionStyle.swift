import UIKit

/// Стили переходов с участием UIPopoverController
public enum PopoverTransitionStyle {
    case popoverFromView(
        sourceView: UIView,
        sourceRect: CGRect
    )
    
    case popoverFromBarButtonItem(
        buttonItem: UIBarButtonItem
    )
}
