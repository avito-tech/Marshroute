/// Базовый класс для анимирующих обработчиков переходов
class AnimatingTransitionsHandler: TransitionAnimationsLauncher, TransitionsCoordinatorHolder {
    
// пришлось сделать классом, а не композицией протоколов, и не typealias'ом на композицию протоколов,
// из-за странного поведения.
// typealias P = protocol<A, B>` не будет подходить под ограничение
// `where T: B` на дженерик тип T
    
    // MARK: - TransitionsCoordinatorHolder
    let transitionsCoordinator: TransitionsCoordinator
    
    init(transitionsCoordinator: TransitionsCoordinator)
    {
        self.transitionsCoordinator = transitionsCoordinator
    }
    
    // MARK: - TransitionAnimationsLauncher
    func launchAnimationOfPerformingTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext) {}
    
    func launchAnimationOfUndoingTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext) {}
    
    func launchAnimationOfResettingWithTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext) {}
}

// MARK: - TransitionsHandler
extension AnimatingTransitionsHandler: TransitionsHandler {}