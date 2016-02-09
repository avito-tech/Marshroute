final class PopoverAnimationContextCreator {
    let transitionStyleConverter: PopoverTransitionStyleConverter = PopoverTransitionStyleConverter()
}

extension PopoverAnimationContextCreator: TransitionAnimationContextCreator {
    func createAnimationContextForTransition(
        transitionStyle transitionStyle: TransitionStyle,
        animationSourceParameters: PopoverAnimationSourceParameters,
        animationTargetParameters: TransitionAnimationTargetParameters?)
        -> PopoverAnimationContext?
    {
        guard let animationStyle = transitionStyleConverter.convertTransitionStyle(transitionStyle)
            else { return nil }
        
        guard let popoverController = animationSourceParameters.popoverController
            else { return nil }
        
        let result = PopoverAnimationContext(
            popoverController: popoverController,
            animationStyle: animationStyle)
        
        return result
    }
}
