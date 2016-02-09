protocol NavigationTransitionsAnimator: class {
    func animatePerformingNavigationTransition(animationContext context: NavigationAnimationContext)
    func animateUndoingNavigationTransition(animationContext context: NavigationAnimationContext)
    func animateResettingWithNavigationTransition(animationContext context: NavigationAnimationContext)
}