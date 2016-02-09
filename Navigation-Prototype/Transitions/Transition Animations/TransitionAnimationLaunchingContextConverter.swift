/// Создание контекста анимации из контекста запуска анимации
protocol TransitionAnimationLaunchingContextConverter: class {
    typealias TransitionAnimationContext
    
    func convertAnimationLaunchingContextToAnimationContext(context: TransitionAnimationLaunchingContext)
        -> TransitionAnimationContext?
}