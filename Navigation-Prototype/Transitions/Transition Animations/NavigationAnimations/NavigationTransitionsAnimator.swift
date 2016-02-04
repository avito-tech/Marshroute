final class NavigationTransitionsAnimator {}

extension NavigationTransitionsAnimator: TransitionsAnimator {
    func animatePerformingTransition(animationContext context: TransitionAnimationContext) {
        guard let context = context as? NavigationAnimationContext
            else { assert(false, "bad animation context"); return }
        
        switch context.animationStyle {
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
    
    func animateUndoingTransition(animationContext context: TransitionAnimationContext) {
        guard let context = context as? NavigationAnimationContext
            else { assert(false, "bad animation context"); return }
        
        switch context.animationStyle {
        case .Push:
            context.navigationController.popToViewController(context.targetViewController, animated: true)
        case .Modal:
            context.navigationController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func animateResettingWithTransition(animationContext context: TransitionAnimationContext) {
        guard let context = context as? NavigationAnimationContext
            else { assert(false, "bad animation context"); return }
        
        switch context.animationStyle {
        case .Push:
            context.navigationController.setViewControllers([context.targetViewController], animated: true)
        case .Modal:
            assert(false, "must not be called")
        }
    }
}
