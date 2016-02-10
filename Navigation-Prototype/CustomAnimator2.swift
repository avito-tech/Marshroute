import UIKit

// MARK: - NavigationControllerDelegate
final private class NavigationControllerDelegate: NSObject {
    weak var viewControllerAnimatedTransitioningDelegate: ViewControllerAnimatedTransitioningDelegateImpl?
}

// MARK: - ViewControllerAnimatedTransitioningDelegateImpl
final private class ViewControllerAnimatedTransitioningDelegateImpl: NSObject {}

// MARK: - CustomAnimator2
class CustomAnimator2: BaseNavigationTransitionsAnimator {
    private let navigationControllerDelegate = NavigationControllerDelegate()
    private let viewControllerAnimatedTransitioningDelegate = ViewControllerAnimatedTransitioningDelegateImpl()
    
    override init() {
        super.init()
        navigationControllerDelegate.viewControllerAnimatedTransitioningDelegate = viewControllerAnimatedTransitioningDelegate
    }
    
    override func animatePerformingTransition(animationContext context: NavigationAnimationContext)
    {
        switch context.animationStyle {
        case .Push:
            let nvc = context.navigationController
            nvc.delegate = navigationControllerDelegate
            
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
    
    override func animateUndoingTransition(animationContext context: NavigationAnimationContext)
    {
        switch context.animationStyle {
        case .Push:
            context.navigationController.popToViewController(context.targetViewController, animated: true)
        case .Modal:
            context.navigationController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func animateResettingWithTransition(animationContext context: NavigationAnimationContext) {
        switch context.animationStyle {
        case .Push:
            context.navigationController.setViewControllers([context.targetViewController], animated: true)
        case .Modal:
            assert(false, "must not be called"); break
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension NavigationControllerDelegate: UINavigationControllerDelegate {
    @objc func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return viewControllerAnimatedTransitioningDelegate
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension ViewControllerAnimatedTransitioningDelegateImpl: UIViewControllerAnimatedTransitioning {
    @objc func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.7
    }
    
    @objc func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // get reference to our fromView, toView and the container view that we should perform the transition in
        if #available(iOS 8.0, *) {
            guard let container = transitionContext.containerView()
                else { return }
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            
            // set up from 2D transforms that we'll use in the animation
            let offScreenRight = CGAffineTransformMakeTranslation(container.frame.width, container.frame.height)
            let offScreenLeft = CGAffineTransformMakeTranslation(-container.frame.width, container.frame.height)
            
            // start the toView to the right of the screen
            toView.transform = CGAffineTransformRotate(offScreenRight, 1)
            
            // add the both views to our view controller
            container.addSubview(toView)
            container.addSubview(fromView)
            
            // get the duration of the animation
            // DON'T just type '0.5s' -- the reason why won't make sense until the next post
            // but for now it's important to just follow this approach
            let duration = self.transitionDuration(transitionContext)
            
            // perform the animation!
            // for this example, just slid both fromView and toView to the left at the same time
            // meaning fromView is pushed off the screen and toView slides into view
            // we also use the block animation usingSpringWithDamping for a little bounce
            UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: [.CurveEaseInOut], animations: {
                
                fromView.transform = offScreenLeft
                toView.transform = CGAffineTransformIdentity
                
                }, completion: { finished in
                    
                    // tell our transitionContext object that we've finished animating
                    transitionContext.completeTransition(true)
                    
            })
        }
    }
    
    @objc func animationEnded(transitionCompleted: Bool) {
        
    }
}