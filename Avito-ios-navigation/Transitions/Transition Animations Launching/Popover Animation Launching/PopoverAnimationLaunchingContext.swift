/// Описание параметров запуска анимаций с участием UIPopoverController
struct PopoverAnimationLaunchingContext {
    /// стиль перехода
    let transitionStyle: PopoverTransitionStyle
    
    /// параметры анимации перехода, получаемые из информации об исходной точке прямого или обратного перехода
    var animationSourceParameters: PopoverAnimationSourceParameters
    
    /// параметры анимации перехода, получаемые из информации о конечной точке прямого или обратного перехода
    let animationTargetParameters: PopoverAnimationTargetParameters
    
    /// аниматор, выполняющий анимации прямого и обратного перехода
    let animator: PopoverTransitionsAnimator
}