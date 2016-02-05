final class NavigationAnimationContextCreator {
    let transitionStyleConverter: NavigationTransitionStyleConverter = NavigationTransitionStyleConverter()
}

extension NavigationAnimationContextCreator: TransitionAnimationContextCreator {
    typealias TransitionAnimationSourceParameters = NavigationAnimationSourceParameters
    
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
            
            guard let navigationController = animationSourceParameters.navigationController
                else { return nil }
            
            guard let targetViewController = animationTargetParameters.viewController
                else { return nil }
            
            let result = NavigationAnimationContext(
                navigationController: navigationController,
                targetViewController: targetViewController,
                animationStyle: animationStyle)
            
            return result
    }
}