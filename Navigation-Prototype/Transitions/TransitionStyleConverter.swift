protocol TransitionStyleConverter: class {
    typealias ConvertedAnimationStyle
    
    func convertTransitionStyle(style: TransitionStyle) -> ConvertedAnimationStyle?
}