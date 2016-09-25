final class TransitionsCoordinatorSpy: TransitionsCoordinator
{
    // MARK: - Performing
    
    var coordinatePerformingTransition: CoordinatePerformingTransition!
    
    func coordinatePerformingTransition(
        context: PresentationTransitionContext,
                forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    {
        coordinatePerformingTransition = .forAnimating(
            context: context,
            transitionsHandler: transitionsHandler
        )
    }
    
    func coordinatePerformingTransition(
        context: PresentationTransitionContext,
                forContainingTransitionsHandler transitionsHandler: ContainingTransitionsHandler)
    {
        coordinatePerformingTransition = .forContaining(
            context: context,
            transitionsHandler: transitionsHandler
        )
    }
    
    // MARK: - Undoing After
    
    var coordinateUndoingTransitionsAfter: CoordinateUndoingTransitionsAfter!
    
    func coordinateUndoingTransitionsAfter(
        transitionId: TransitionId,
                     forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    {
        coordinateUndoingTransitionsAfter = .forAnimating(
            transitionId: transitionId,
            transitionsHandler: transitionsHandler
        )
    }
    
    func coordinateUndoingTransitionsAfter(
        transitionId: TransitionId,
                     forContainingTransitionsHandler transitionsHandler: ContainingTransitionsHandler)
    {
        coordinateUndoingTransitionsAfter = .forContaining(
            transitionId: transitionId,
            transitionsHandler: transitionsHandler
        )
    }
    
    // MARK: - Undoing With
    
    var coordinateUndoingTransitionWith: CoordinateUndoingTransitionWith!
    
    func coordinateUndoingTransitionWith(
        transitionId: TransitionId,
                     forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    {
        coordinateUndoingTransitionWith = .forAnimating(
            transitionId: transitionId,
            transitionsHandler: transitionsHandler
        )
    }
    
    func coordinateUndoingTransitionWith(
        transitionId: TransitionId,
                     forContainingTransitionsHandler transitionsHandler: ContainingTransitionsHandler)
    {
        coordinateUndoingTransitionWith = .forContaining(
            transitionId: transitionId,
            transitionsHandler: transitionsHandler
        )
    }
    
    // MARK: - Undoing All Chained
    var coordinateUndoingAllChainedTransitions: CoordinateUndoingAllChainedTransitions?
    
    func coordinateUndoingAllChainedTransitions(
        forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    {
        coordinateUndoingAllChainedTransitions = .forAnimating(
            transitionsHandler: transitionsHandler
        )
    }
    
    // MARK: - Undoing All
    
    var coordinateUndoingAllTransitions: CoordinateUndoingAllTransitions?
    
    func coordinateUndoingAllTransitions(
        forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    {
        coordinateUndoingAllTransitions = .forAnimating(
            transitionsHandler: transitionsHandler
        )
    }
    
    // MARK: - Resetting
    
    var coordinateResettingWithTransition: CoordinateResettingWithTransition?
    
    func coordinateResettingWithTransition(
        context: ResettingTransitionContext,
                forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    {
        coordinateResettingWithTransition = .forAnimating(
            context: context,
            transitionsHandler: transitionsHandler
        )
    }
}
