final class TransitionAnimationLaunchingContextConverterImpl {}

// MARK: - TransitionAnimationLaunchingContextConverter
extension TransitionAnimationLaunchingContextConverterImpl: TransitionAnimationLaunchingContextConverter {

    @warn_unused_result
    func convertAnimationLaunchingContextToAnimationContext(context: TransitionAnimationLaunchingContext)
        -> TransitionAnimationContext?
    {
        var animationContext: TransitionAnimationContext? = nil
        
        switch context.transitionStyle {
        case .Push, .Modal:
            guard let navigationAnimationSourceParameters = context.animationSourceParameters as? NavigationAnimationSourceParameters else {
                assert(false, "нужны другие исходные параметры анимации \(context.animationSourceParameters)" +
                    "для навигационного перехода: \(context)")
                break
            }

            let creator = NavigationAnimationContextCreator()
            
            animationContext = creator.createAnimationContextForTransition(
                transitionStyle: context.transitionStyle,
                animationSourceParameters: navigationAnimationSourceParameters,
                animationTargetParameters: context.animationTargetParameters)
            
        case .PopoverFromButtonItem(_), .PopoverFromView(_, _):
            guard let popoverAnimationSourceParameters = context.animationSourceParameters as? PopoverAnimationSourceParameters else {
                assert(false, "You passed wrong source animation parameters \(context.animationSourceParameters)" +
                    "for popover transition: \(context)")
                break
            }
            
            let creator = PopoverAnimationContextCreator()
            
            animationContext = creator.createAnimationContextForTransition(
                transitionStyle: context.transitionStyle,
                animationSourceParameters: popoverAnimationSourceParameters,
                animationTargetParameters: context.animationTargetParameters)
        }
        
        return animationContext
    }
}