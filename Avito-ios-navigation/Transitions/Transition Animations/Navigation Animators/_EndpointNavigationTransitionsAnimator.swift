//public class EndpointNavigationTransitionsAnimator: NavigationTransitionsAnimator
//{        
//    override public func animateResettingWithTransition(animationContext context: NavigationAnimationContext)
//    {
//        switch context.transitionStyle {
//        case .Push:
//            debugPrint("Do not call `setViewControllers(_:animated:)` because the target view controller is `UINavigationController`")
//            break
//        
//        case .Modal:
//            super.animateResettingWithTransition(animationContext: context)
//        }
//    }
//}