/// Описание параметров запуска анимаций с участием UINavigationController
public struct NavigationAnimationLaunchingContext {
    /// стиль перехода
    public let transitionStyle: NavigationTransitionStyle
    
    /// параметры анимации перехода, получаемые из информации о конечной точке прямого или обратного перехода
    public let animationTargetParameters: NavigationAnimationTargetParameters
    
    /// аниматор, выполняющий анимации прямого и обратного перехода
    public let animator: NavigationTransitionsAnimator
    
    public init(
        transitionStyle: NavigationTransitionStyle,
        animationTargetParameters: NavigationAnimationTargetParameters,
        animator: NavigationTransitionsAnimator)
    {
        self.transitionStyle = transitionStyle
        self.animationTargetParameters = animationTargetParameters
        self.animator = animator
    }
}