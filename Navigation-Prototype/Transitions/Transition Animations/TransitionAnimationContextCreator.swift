/// Создание анимационного контекста
protocol TransitionAnimationContextCreator: class {
    typealias TransitionAnimationSourceParameters
    
    func createAnimationContextForTransition(
        transitionStyle transitionStyle: TransitionStyle,
        animationSourceParameters: TransitionAnimationSourceParameters,
        animationTargetParameters: TransitionAnimationTargetParameters?)
        -> TransitionAnimationContext?
}