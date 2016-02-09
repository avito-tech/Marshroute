class CustomAnimator1 {}

// MARK: - NavigationTransitionsAnimator
extension CustomAnimator1: NavigationTransitionsAnimator {
    func animatePerformingNavigationTransition(animationContext context: NavigationAnimationContext)
    {
        switch context.animationStyle {
        case .Push:
            context.navigationController.pushViewController(
                context.targetViewController,
                animated: true)
        case .Modal:
            let viewController = context.targetViewController
            viewController.modalPresentationStyle = .FormSheet
            
            context.navigationController.presentViewController(
                viewController,
                animated: true,
                completion: nil)
        }
    }
    
    func animateUndoingNavigationTransition(animationContext context: NavigationAnimationContext)
    {
        switch context.animationStyle {
        case .Push:
            context.navigationController.popToViewController(context.targetViewController, animated: true)
        case .Modal:
            context.navigationController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func animateResettingWithNavigationTransition(animationContext context: NavigationAnimationContext)
    {
        switch context.animationStyle {
        case .Push:
            context.navigationController.setViewControllers([context.targetViewController], animated: true)
        case .Modal:
            assert(false, "must not be called"); break
        }
    }
}