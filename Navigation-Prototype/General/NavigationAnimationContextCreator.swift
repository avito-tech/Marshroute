final class NavigationAnimationContextCreator {
    let transitionStyleConverter: NavigationTransitionStyleConverter = NavigationTransitionStyleConverter()
}

extension NavigationAnimationContextCreator: TransitionAnimationContextCreator {
    typealias AnimationSourceParameters = NavigationAnimationSourceParameters
    
    @warn_unused_result
    func createAnimationContextForTransition(
        transitionStyle transitionStyle: TransitionStyle,
        animationSourceParameters: NavigationAnimationSourceParameters,
        animationTargetParameters: TransitionAnimationTargetParameters?)
        -> TransitionAnimationContext? {
            
            guard let animationStyle = transitionStyleConverter.convertTransitionStyle(transitionStyle)
                else { return nil }
            
            guard let animationTargetParameters = animationTargetParameters
                else { return nil }
            
            let result = NavigationAnimationContext(
                navigationController: animationSourceParameters.navigationController,
                targetViewController: animationTargetParameters.viewController,
                animationStyle: animationStyle)
            
            return result
    }
}