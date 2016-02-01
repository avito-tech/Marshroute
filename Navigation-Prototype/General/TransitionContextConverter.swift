protocol TransitionContextConverter {
    
    func convertForwardTransition(
        context context: ForwardTransitionContext,
        toAnimationContextWithAnimationSourceParameters animationSourceParameters: TransitionAnimationSourceParameters)
        -> TransitionAnimationContext?
    
    func convertRestoredTransition(
        context context: RestoredTransitionContext,
        toAnimationContextWithAnimationSourceParameters animationSourceParameters: TransitionAnimationSourceParameters)
        -> TransitionAnimationContext?

}