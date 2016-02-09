/// Создание анимационного контекста из параметров
protocol TransitionAnimationContextCreator: class {
    typealias TransitionAnimationSourceParameters
    typealias TransitionAnimationContext
    
    func createAnimationContextForTransition(
        transitionStyle transitionStyle: TransitionStyle,
        animationSourceParameters: TransitionAnimationSourceParameters,
        animationTargetParameters: TransitionAnimationTargetParameters?)
        -> TransitionAnimationContext?
}