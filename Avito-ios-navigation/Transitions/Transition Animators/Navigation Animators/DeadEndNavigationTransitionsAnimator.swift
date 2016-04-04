public class DeadEndNavigationTransitionsAnimator: NavigationTransitionsAnimator {
        
    override public func animateResettingWithTransition(animationContext context: NavigationAnimationContext)
    {
        switch context.transitionStyle {
        case .Push:
            // do not call `setViewControllers(_:animated:)` because the target view controller is `UINavigationController`
            break
        
        case .Modal:
            assert(false, "must not be called"); break
        }
    }
}