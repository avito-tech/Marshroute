/// Базовый класс для анимирующих обработчиков переходов
class AnimatingTransitionsHandler: TransitionAnimationsLauncher, TransitionsCoordinatorHolder {
    
// пришлось сделать классом, а не композицией протоколов и не typealias'ом на композицию протоколов,
// из-за того, что этот обработчик переходов кладется в дженерик `Box<T>`
    
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
extension AnimatingTransitionsHandler: TransitionsHandler {
    func performTransition(context context: ForwardTransitionContext)
    {
        transitionsCoordinator.coordinatePerformingTransition(context: context, forAnimatingTransitionsHandler: self)
    }
    
    func undoTransitionsAfter(transitionId transitionId: TransitionId)
    {
        transitionsCoordinator.coordinateUndoingTransitionsAfter(transitionId: transitionId, forAnimatingTransitionsHandler: self)
    }
    
    func undoTransitionWith(transitionId transitionId: TransitionId)
    {
        transitionsCoordinator.coordinateUndoingTransitionWith(transitionId: transitionId, forAnimatingTransitionsHandler: self)
    }
    
    func undoAllChainedTransitions()
    {
        transitionsCoordinator.coordinateUndoingAllChainedTransitions(forAnimatingTransitionsHandler: self)
    }
    
    func undoAllTransitions()
    {
        transitionsCoordinator.coordinateUndoingAllTransitions(forAnimatingTransitionsHandler: self)
    }
    
    func resetWithTransition(context context: ForwardTransitionContext)
    {
        transitionsCoordinator.coordinateResettingWithTransition(context: context, forAnimatingTransitionsHandler: self)
    }
}