final class PopoverAnimationContextCreator {
    let transitionStyleConverter: PopoverTransitionStyleConverter = PopoverTransitionStyleConverter()
}

extension PopoverAnimationContextCreator: TransitionAnimationContextCreator {
    typealias AnimationSourceParameters = PopoverAnimationSourceParameters
    
    @warn_unused_result
    func createAnimationContextForTransition(
        transitionStyle transitionStyle: TransitionStyle,
        animationSourceParameters: PopoverAnimationSourceParameters,
        animationTargetParameters: TransitionAnimationTargetParameters?)
        -> TransitionAnimationContext? {
            
            guard let animationStyle = transitionStyleConverter.convertTransitionStyle(transitionStyle)
                else { return nil }
            
            let result = PopoverAnimationContext(
                popoverController: animationSourceParameters.popoverController,
                animationStyle: animationStyle)

            return result
    }
}
