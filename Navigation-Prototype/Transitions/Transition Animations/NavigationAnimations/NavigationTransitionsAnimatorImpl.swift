final class NavigationTransitionsAnimatorImpl {}

// MARK: - NavigationTransitionsAnimator
extension NavigationTransitionsAnimatorImpl: NavigationTransitionsAnimator {
    func animatePerformingNavigationTransition(animationContext context: NavigationAnimationContext) {
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
    
    func animateUndoingNavigationTransition(animationContext context: NavigationAnimationContext) {
        switch context.animationStyle {
        case .Push:
            context.navigationController.popToViewController(context.targetViewController, animated: true)
        case .Modal:
            context.navigationController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func animateResettingWithNavigationTransition(animationContext context: NavigationAnimationContext) {
        switch context.animationStyle {
        case .Push:
            context.navigationController.setViewControllers([context.targetViewController], animated: true)
        case .Modal:
            assert(false, "must not be called"); break
        }
    }
}

// MARK: - TransitionsAnimator
extension NavigationTransitionsAnimatorImpl: TransitionsAnimator {}