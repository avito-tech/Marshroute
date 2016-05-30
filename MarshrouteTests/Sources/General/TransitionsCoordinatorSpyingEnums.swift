enum CoordinatePerformingTransition {
    case ForAnimating(
        context: PresentationTransitionContext,
        transitionsHandler: AnimatingTransitionsHandler
    )
    case ForContaining(
        context: PresentationTransitionContext,
        transitionsHandler: ContainingTransitionsHandler
    )
}

enum CoordinateUndoingTransitionsAfter {
    case ForAnimating(
        transitionId: TransitionId,
        transitionsHandler: AnimatingTransitionsHandler
    )
    case ForContaining(
        transitionId: TransitionId,
        transitionsHandler: ContainingTransitionsHandler
    )
}

enum CoordinateUndoingTransitionWith {
    case ForAnimating(
        transitionId: TransitionId,
        transitionsHandler: AnimatingTransitionsHandler
    )
    case ForContaining(
        transitionId: TransitionId,
        transitionsHandler: ContainingTransitionsHandler
    )
}

enum CoordinateUndoingAllChainedTransitions {
    case ForAnimating(
        transitionsHandler: AnimatingTransitionsHandler
    )
}

enum CoordinateUndoingAllTransitions {
    case ForAnimating(
        transitionsHandler: AnimatingTransitionsHandler
    )
}

enum CoordinateResettingWithTransition {
    case ForAnimating(
        context: ResettingTransitionContext,
        transitionsHandler: AnimatingTransitionsHandler
    )
}