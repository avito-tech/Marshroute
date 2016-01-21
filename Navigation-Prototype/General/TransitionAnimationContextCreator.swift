protocol TransitionAnimationContextCreator: class {
    typealias AnimationSourceParameters
    
    func createAnimationContextForTransition(
        transitionStyle transitionStyle: TransitionStyle,
        animationSourceParameters: AnimationSourceParameters,
        animationTargetParameters: TransitionAnimationTargetParameters?)
        -> TransitionAnimationContext?
}