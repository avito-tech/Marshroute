final class NavigationTransitionStyleConverter {}

extension NavigationTransitionStyleConverter: TransitionStyleConverter {
    typealias ConvertedAnimationStyle = NavigationAnimationStyle
    
    func convertTransitionStyle(style: TransitionStyle) -> NavigationAnimationStyle? {
        switch style {
        case .Push:
            return .Push
        case .Modal:
            return .Modal
        default:
            return nil
        }
    }
}