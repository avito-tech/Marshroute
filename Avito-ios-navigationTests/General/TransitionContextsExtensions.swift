func ==(a: PresentationTransitionContext, b: PresentationTransitionContext) -> Bool {
    if a.transitionId != b.transitionId { return false }
    if a.targetViewController !== b.targetViewController { return false }
    return true
}

func ==(a: ResettingTransitionContext, b: ResettingTransitionContext) -> Bool {
    if a.transitionId != b.transitionId { return false }
    if a.targetViewController !== b.targetViewController { return false }
    return true
}