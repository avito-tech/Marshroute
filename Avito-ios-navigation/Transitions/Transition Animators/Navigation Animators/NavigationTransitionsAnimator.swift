public class NavigationTransitionsAnimator: TransitionsAnimator {
    
    public var shouldAnimate = true
    
    // MARK: - Init
    public init() {}
    
    // MARK: - TransitionsAnimator
    public func animatePerformingTransition(animationContext context: NavigationAnimationContext)
    {
        switch context.transitionStyle {
        case .Push:
            context.navigationController.pushViewController(
                context.targetViewController,
                animated: shouldAnimate
            )
            
        case .Modal:
            context.navigationController.presentViewController(
                context.targetViewController,
                animated: shouldAnimate,
                completion: nil
            )
        }
        
        shouldAnimate = true
    }
    
    public func animateUndoingTransition(animationContext context: NavigationAnimationContext)
    {
        switch context.transitionStyle {
        case .Push:
            context.navigationController.popToViewController(
                context.targetViewController,
                animated: shouldAnimate
            )

        case .Modal:
            context.navigationController.dismissViewControllerAnimated(
                shouldAnimate,
                completion: nil
            )
        }
        
        shouldAnimate = true
    }
    
    public func animateResettingWithTransition(animationContext context: NavigationAnimationContext)
    {
        switch context.transitionStyle {
        case .Push:
            context.navigationController.setViewControllers(
                [context.targetViewController],
                animated: shouldAnimate
            )
        
        case .Modal:
            assert(false, "must not be called"); break
        }
        
        shouldAnimate = true
    }
}