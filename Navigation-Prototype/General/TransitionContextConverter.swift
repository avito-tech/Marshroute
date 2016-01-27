final class TransitionContextConverter {
    
    @warn_unused_result
    func convertForwardTransition(
        context context: ForwardTransitionContext,
        toAnimationContextWithAnimationSourceParameters animationSourceParameters: TransitionAnimationSourceParameters)
        -> TransitionAnimationContext?
    {
        var animationContext: TransitionAnimationContext? = nil
        
        switch context.transitionStyle {
        case .Push, .Modal:
            guard let navigationAnimationSourceParameters = animationSourceParameters as? NavigationAnimationSourceParameters else {
                assert(false, "You passed wrong source animation parameters \(animationSourceParameters)" +
                    "for navigation transition: \(context)")
                break
            }
            
            guard let transitionAnimationTargetParameters = context.animationTargetParameters else {
                assert(false, "You must always provide target animation parameters \(context.animationTargetParameters)" +
                    "for navigation transition: \(context)")
                break
            }
            
            let creator = NavigationAnimationContextCreator()
            
            animationContext = creator.createAnimationContextForTransition(
                transitionStyle: context.transitionStyle,
                animationSourceParameters: navigationAnimationSourceParameters,
                animationTargetParameters: transitionAnimationTargetParameters)
            
        case .PopoverFromButtonItem(_), .PopoverFromView(_, _):
            guard let popoverAnimationSourceParameters = animationSourceParameters as? PopoverAnimationSourceParameters else {
                assert(false, "You passed wrong source animation parameters \(animationSourceParameters)" +
                    "for popover transition: \(context)")
                break
            }
            
            let creator = PopoverAnimationContextCreator()
            
            animationContext = creator.createAnimationContextForTransition(
                transitionStyle: context.transitionStyle,
                animationSourceParameters: popoverAnimationSourceParameters,
                animationTargetParameters: nil)
        }
        
        return animationContext
    }
    
    @warn_unused_result
    func convertRestoredTransition(
        context context: RestoredTransitionContext,
        toAnimationContextWithAnimationSourceParameters animationSourceParameters: TransitionAnimationSourceParameters)
        -> TransitionAnimationContext?
    {
        var animationContext: TransitionAnimationContext? = nil
        
        switch context.transitionStyle {
        case .Push, .Modal:
            guard let navigationAnimationSourceParameters = animationSourceParameters as? NavigationAnimationSourceParameters else {
                assert(false, "You passed wrong source animation parameters \(animationSourceParameters)" +
                    "for navigation transition: \(context)")
                break
            }
            
            let creator = NavigationAnimationContextCreator()
            
            animationContext = creator.createAnimationContextForTransition(
                transitionStyle: context.transitionStyle,
                animationSourceParameters: navigationAnimationSourceParameters,
                animationTargetParameters: context.animationTargetParameters)
            
        case .PopoverFromButtonItem(_), .PopoverFromView(_, _):
            guard let popoverAnimationSourceParameters = animationSourceParameters as? PopoverAnimationSourceParameters else {
                assert(false, "You passed wrong source animation parameters \(animationSourceParameters)" +
                    "for popover transition: \(context)")
                break
            }
            
            let creator = PopoverAnimationContextCreator()
            
            animationContext = creator.createAnimationContextForTransition(
                transitionStyle: context.transitionStyle,
                animationSourceParameters: popoverAnimationSourceParameters,
                animationTargetParameters: nil)
        }
        
        return animationContext
    }
}

