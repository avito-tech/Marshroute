/// Описание параметров запуска анимации
struct TransitionAnimationLaunchingContext {
    /// стиль перехода
    let transitionStyle: TransitionStyle
    
    /// объект, выполняющий анимацию перехода
    let animator: TransitionsAnimator

    /// параметры анимации перехода, получаемые из информации об исходной точке прямого или обратного перехода
    var animationSourceParameters: TransitionAnimationSourceParameters?
    
    /// параметры анимации перехода, получаемые из информации о конечной точке прямого или обратного перехода
    let animationTargetParameters: TransitionAnimationTargetParameters
}