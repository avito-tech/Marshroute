/// Описание параметров запуска анимаций с участием UIPopoverController
public struct PopoverAnimationLaunchingContext {
    /// стиль перехода
    public let transitionStyle: PopoverTransitionStyle
    
    /// параметры анимации перехода, получаемые из информации об исходной точке прямого или обратного перехода
    public var animationSourceParameters: PopoverAnimationSourceParameters
    
    /// параметры анимации перехода, получаемые из информации о конечной точке прямого или обратного перехода
    public let animationTargetParameters: PopoverAnimationTargetParameters
    
    /// аниматор, выполняющий анимации прямого и обратного перехода
    public let animator: PopoverTransitionsAnimator
    
    public init(
        transitionStyle: PopoverTransitionStyle,
        animationSourceParameters: PopoverAnimationSourceParameters,
        animationTargetParameters: PopoverAnimationTargetParameters,
        animator: PopoverTransitionsAnimator)
    {
        self.transitionStyle = transitionStyle
        self.animationSourceParameters = animationSourceParameters
        self.animationTargetParameters = animationTargetParameters
        self.animator = animator
    }
}