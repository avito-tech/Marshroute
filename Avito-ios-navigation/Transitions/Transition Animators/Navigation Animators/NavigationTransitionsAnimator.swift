public class NavigationTransitionsAnimator: TransitionsAnimator {
    
    private var animated = true
    
    // MARK: - Init
    public init() {}
    
    // MARK: - TransitionsAnimator
    public func animatePerformingTransition(animationContext context: NavigationAnimationContext)
    {
        switch context.transitionStyle {
        case .Push:
            context.navigationController.pushViewController(
                context.targetViewController,
                animated: animated)
            
        case .Modal:
            context.navigationController.presentViewController(
                context.targetViewController,
                animated: animated,
                completion: nil)
        }
        
        becomeAnimated()
    }
    
    public func animateUndoingTransition(animationContext context: NavigationAnimationContext)
    {
        switch context.transitionStyle {
        case .Push:
            context.navigationController.popToViewController(
                context.targetViewController,
                animated: animated
            )

        case .Modal:
            context.navigationController.dismissViewControllerAnimated(
                animated,
                completion: nil
            )
        }
        
        becomeAnimated()
    }
    
    public func animateResettingWithTransition(animationContext context: NavigationAnimationContext)
    {
        switch context.transitionStyle {
        case .Push:
            context.navigationController.setViewControllers(
                [context.targetViewController],
                animated: animated
            )
        
        case .Modal:
            assert(false, "must not be called"); break
        }
        
        becomeAnimated()
    }
    
    // MARK: - public
    public func becomeAnimated() {
        animated = true
    }
    
    public func becomeNotAnimated() {
        animated = false
    }
}