/// Базовый класс для анимирующих обработчиков переходов
public class AnimatingTransitionsHandler: TransitionAnimationsLauncher, TransitionsCoordinatorHolder, TransitionsHandler {
    // MARK: - TransitionsCoordinatorHolder
    public let transitionsCoordinator: TransitionsCoordinator
    
    public init(transitionsCoordinator: TransitionsCoordinator)
    {
        self.transitionsCoordinator = transitionsCoordinator
    }
    
    // MARK: - TransitionAnimationsLauncher
    public func launchAnimationOfPerformingTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext) {
        launchingContext.launchAnimationOfPerformingTransition()
    }

    public func launchAnimationOfUndoingTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext) {
        launchingContext.launchAnimationOfUndoingTransition()
    }
    
    public func launchAnimationOfResettingWithTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext) {
        launchingContext.launchAnimationOfResettingWithTransition()
    }

    // MARK: - TransitionsHandler
    public func performTransition(context context: ForwardTransitionContext)
    {
        transitionsCoordinator.coordinatePerformingTransition(context: context, forAnimatingTransitionsHandler: self)
    }
    
    public func undoTransitionsAfter(transitionId transitionId: TransitionId)
    {
        transitionsCoordinator.coordinateUndoingTransitionsAfter(transitionId: transitionId, forAnimatingTransitionsHandler: self)
    }
    
    public func undoTransitionWith(transitionId transitionId: TransitionId)
    {
        transitionsCoordinator.coordinateUndoingTransitionWith(transitionId: transitionId, forAnimatingTransitionsHandler: self)
    }
    
    public func undoAllChainedTransitions()
    {
        transitionsCoordinator.coordinateUndoingAllChainedTransitions(forAnimatingTransitionsHandler: self)
    }
    
    public func undoAllTransitions()
    {
        transitionsCoordinator.coordinateUndoingAllTransitions(forAnimatingTransitionsHandler: self)
    }
    
    public func resetWithTransition(context context: ForwardTransitionContext)
    {
        transitionsCoordinator.coordinateResettingWithTransition(context: context, forAnimatingTransitionsHandler: self)
    }
}