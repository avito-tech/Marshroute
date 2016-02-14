class CustomAnimator1: NavigationTransitionsAnimator {
    override func animatePerformingTransition(animationContext context: NavigationAnimationContext)
    {
        switch context.transitionStyle {
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
}