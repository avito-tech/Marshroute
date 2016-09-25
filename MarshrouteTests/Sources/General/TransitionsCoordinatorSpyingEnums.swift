enum CoordinatePerformingTransition {
    case forAnimating(
        context: PresentationTransitionContext,
        transitionsHandler: AnimatingTransitionsHandler
    )
    case forContaining(
        context: PresentationTransitionContext,
        transitionsHandler: ContainingTransitionsHandler
    )
}

enum CoordinateUndoingTransitionsAfter {
    case forAnimating(
        transitionId: TransitionId,
        transitionsHandler: AnimatingTransitionsHandler
    )
    case forContaining(
        transitionId: TransitionId,
        transitionsHandler: ContainingTransitionsHandler
    )
}

enum CoordinateUndoingTransitionWith {
    case forAnimating(
        transitionId: TransitionId,
        transitionsHandler: AnimatingTransitionsHandler
    )
    case forContaining(
        transitionId: TransitionId,
        transitionsHandler: ContainingTransitionsHandler
    )
}

enum CoordinateUndoingAllChainedTransitions {
    case forAnimating(
        transitionsHandler: AnimatingTransitionsHandler
    )
}

enum CoordinateUndoingAllTransitions {
    case forAnimating(
        transitionsHandler: AnimatingTransitionsHandler
    )
}

enum CoordinateResettingWithTransition {
    case forAnimating(
        context: ResettingTransitionContext,
        transitionsHandler: AnimatingTransitionsHandler
    )
}
