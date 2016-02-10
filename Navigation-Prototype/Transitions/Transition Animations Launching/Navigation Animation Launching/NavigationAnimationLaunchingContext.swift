/// Описание параметров запуска анимаций с участием UINavigationController
struct NavigationAnimationLaunchingContext {
    /// стиль перехода
    let transitionStyle: NavigationTransitionStyle
    
    /// параметры анимации перехода, получаемые из информации о конечной точке прямого или обратного перехода
    let animationTargetParameters: NavigationAnimationTargetParameters
    
    /// аниматор, выполняющий анимации прямого и обратного перехода
    let animator: BaseNavigationTransitionsAnimator
}