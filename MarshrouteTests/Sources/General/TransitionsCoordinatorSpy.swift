final class TransitionsCoordinatorSpy: TransitionsCoordinator
{
    // MARK: - Performing
    
    var coordinatePerformingTransition: CoordinatePerformingTransition!
    
    func coordinatePerformingTransition(
        context context: PresentationTransitionContext,
                forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    {
        coordinatePerformingTransition = .ForAnimating(
            context: context,
            transitionsHandler: transitionsHandler
        )
    }
    
    func coordinatePerformingTransition(
        context context: PresentationTransitionContext,
                forContainingTransitionsHandler transitionsHandler: ContainingTransitionsHandler)
    {
        coordinatePerformingTransition = .ForContaining(
            context: context,
            transitionsHandler: transitionsHandler
        )
    }
    
    // MARK: - Undoing After
    
    var coordinateUndoingTransitionsAfter: CoordinateUndoingTransitionsAfter!
    
    func coordinateUndoingTransitionsAfter(
        transitionId transitionId: TransitionId,
                     forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    {
        coordinateUndoingTransitionsAfter = .ForAnimating(
            transitionId: transitionId,
            transitionsHandler: transitionsHandler
        )
    }
    
    func coordinateUndoingTransitionsAfter(
        transitionId transitionId: TransitionId,
                     forContainingTransitionsHandler transitionsHandler: ContainingTransitionsHandler)
    {
        coordinateUndoingTransitionsAfter = .ForContaining(
            transitionId: transitionId,
            transitionsHandler: transitionsHandler
        )
    }
    
    // MARK: - Undoing With
    
    var coordinateUndoingTransitionWith: CoordinateUndoingTransitionWith!
    
    func coordinateUndoingTransitionWith(
        transitionId transitionId: TransitionId,
                     forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    {
        coordinateUndoingTransitionWith = .ForAnimating(
            transitionId: transitionId,
            transitionsHandler: transitionsHandler
        )
    }
    
    func coordinateUndoingTransitionWith(
        transitionId transitionId: TransitionId,
                     forContainingTransitionsHandler transitionsHandler: ContainingTransitionsHandler)
    {
        coordinateUndoingTransitionWith = .ForContaining(
            transitionId: transitionId,
            transitionsHandler: transitionsHandler
        )
    }
    
    // MARK: - Undoing All Chained
    var coordinateUndoingAllChainedTransitions: CoordinateUndoingAllChainedTransitions?
    
    func coordinateUndoingAllChainedTransitions(
        forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    {
        coordinateUndoingAllChainedTransitions = .ForAnimating(
            transitionsHandler: transitionsHandler
        )
    }
    
    // MARK: - Undoing All
    
    var coordinateUndoingAllTransitions: CoordinateUndoingAllTransitions?
    
    func coordinateUndoingAllTransitions(
        forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    {
        coordinateUndoingAllTransitions = .ForAnimating(
            transitionsHandler: transitionsHandler
        )
    }
    
    // MARK: - Resetting
    
    var coordinateResettingWithTransition: CoordinateResettingWithTransition?
    
    func coordinateResettingWithTransition(
        context context: ResettingTransitionContext,
                forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    {
        coordinateResettingWithTransition = .ForAnimating(
            context: context,
            transitionsHandler: transitionsHandler
        )
    }
}