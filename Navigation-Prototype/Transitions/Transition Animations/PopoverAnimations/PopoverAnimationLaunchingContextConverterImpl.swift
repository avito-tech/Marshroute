final class PopoverAnimationLaunchingContextConverterImpl {}

// MARK: - TransitionAnimationLaunchingContextConverter
extension PopoverAnimationLaunchingContextConverterImpl: TransitionAnimationLaunchingContextConverter {
    func convertAnimationLaunchingContextToAnimationContext(context: TransitionAnimationLaunchingContext)
        -> PopoverAnimationContext?
    {
        var animationContext: TransitionAnimationContext? = nil
        
        switch context.transitionStyle {
        case .PopoverFromButtonItem(_), .PopoverFromView(_, _):
            guard let popoverAnimationSourceParameters = context.animationSourceParameters as? PopoverAnimationSourceParameters else {
                assert(false, "нужны другие исходные параметры анимации \(context.animationSourceParameters)" +
                    "для переходов с вызовом поповеров: \(context)")
                break
            }
            
            let creator = PopoverAnimationContextCreator()
             
            animationContext = creator.createAnimationContextForTransition(
                transitionStyle: context.transitionStyle,
                animationSourceParameters: popoverAnimationSourceParameters,
                animationTargetParameters: context.animationTargetParameters)
            
        default:
            assert(false, "must not be called"); break
        }
        
        return animationContext
    }
}