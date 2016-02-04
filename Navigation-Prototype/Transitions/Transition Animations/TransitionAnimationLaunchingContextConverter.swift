/// Создание контекста анимации из контекста запуска анимации
protocol TransitionAnimationLaunchingContextConverter: class {
    func convertAnimationLaunchingContextToAnimationContext(context: TransitionAnimationLaunchingContext)
    -> TransitionAnimationContext?
}