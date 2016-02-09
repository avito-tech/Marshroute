import UIKit

///Стили переходов
enum TransitionStyle {
    case Modal(
        animator: NavigationTransitionsAnimator
    )
    
    case Push(
        animator: NavigationTransitionsAnimator
    )
    
    case PopoverFromView(
        sourceView: UIView,
        sourceRect: CGRect,
        animator: PopoverTransitionsAnimator
    )
    
    case PopoverFromButtonItem(
        buttonItem: UIBarButtonItem,
        animator: PopoverTransitionsAnimator
    )
}