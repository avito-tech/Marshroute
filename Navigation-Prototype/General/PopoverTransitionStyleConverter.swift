final class PopoverTransitionStyleConverter {}

extension PopoverTransitionStyleConverter: TransitionStyleConverter {
    typealias ConvertedAnimationStyle = PopoverAnimationStyle
    
    func convertTransitionStyle(style: TransitionStyle) -> PopoverAnimationStyle? {
        switch style {
        case .PopoverFromButtonItem(let buttonItem):
            return .PresentFromBarButtonItem(buttonItem: buttonItem)
        case .PopoverFromView(let sourceView, let sourceRect):
            return .PresentFromView(sourceView: sourceView, sourceRect: sourceRect)
        default:
            return nil
        }
    }
}
