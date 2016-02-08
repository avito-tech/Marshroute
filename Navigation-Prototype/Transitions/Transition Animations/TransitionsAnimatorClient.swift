/// Запуск анимирования переходов
protocol TransitionsAnimatorClient: class {
    func launchAnimationOfPerformingTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext)
    func launchAnimationOfUndoingTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext)
    func launchAnimationOfResettingWithTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext)
}