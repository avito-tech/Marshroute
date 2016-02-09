final class NavigationTransitionStyleConverter {}

extension NavigationTransitionStyleConverter: TransitionStyleConverter {
    typealias ConvertedAnimationStyle = NavigationAnimationStyle
    
    func convertTransitionStyle(style: TransitionStyle) -> NavigationAnimationStyle? {
        switch style {
        case .Push(_):
            return .Push
        case .Modal(_):
            return .Modal
        default:
            return nil
        }
    }
}