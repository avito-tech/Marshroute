final class NavigationAnimationLaunchingContextConverterImpl {}

// MARK: - TransitionAnimationLaunchingContextConverter
extension NavigationAnimationLaunchingContextConverterImpl: TransitionAnimationLaunchingContextConverter {
    func convertAnimationLaunchingContextToAnimationContext(context: TransitionAnimationLaunchingContext)
        -> NavigationAnimationContext?
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
            
        default:
            assert(false, "must not be called"); break
        }
        
        return animationContext
    }
}