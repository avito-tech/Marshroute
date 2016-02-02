import UIKit

enum PopoverAnimationStyle {
    case PresentFromBarButtonItem(
        buttonItem: UIBarButtonItem
    )
    
    case PresentFromView(
        sourceView: UIView,
        sourceRect: CGRect
    )
}