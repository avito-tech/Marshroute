final class NavigationAnimationContextCreator {
    let transitionStyleConverter: NavigationTransitionStyleConverter = NavigationTransitionStyleConverter()
}

extension NavigationAnimationContextCreator: TransitionAnimationContextCreator {
    func createAnimationContextForTransition(
        transitionStyle transitionStyle: TransitionStyle,
        animationSourceParameters: NavigationAnimationSourceParameters,
        animationTargetParameters: TransitionAnimationTargetParameters?)
        -> NavigationAnimationContext?
    {
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