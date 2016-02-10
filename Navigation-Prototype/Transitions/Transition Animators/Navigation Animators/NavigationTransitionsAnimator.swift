final class NavigationTransitionsAnimator: BaseNavigationTransitionsAnimator {
    override func animatePerformingTransition(animationContext context: NavigationAnimationContext) {
        switch context.transitionStyle {
        case .Push:
            context.navigationController.pushViewController(
                context.targetViewController,
                animated: true)
            
        case .Modal:
            context.navigationController.presentViewController(
                context.targetViewController,
                animated: true,
                completion: nil)
        }
    }
    
    override func animateUndoingTransition(animationContext context: NavigationAnimationContext) {
        switch context.transitionStyle {
        case .Push:
            context.navigationController.popToViewController(context.targetViewController, animated: true)
        case .Modal:
            context.navigationController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func animateResettingWithTransition(animationContext context: NavigationAnimationContext) {
        switch context.transitionStyle {
        case .Push:
            context.navigationController.setViewControllers([context.targetViewController], animated: true)
        case .Modal:
            assert(false, "must not be called"); break
        }
    }
}