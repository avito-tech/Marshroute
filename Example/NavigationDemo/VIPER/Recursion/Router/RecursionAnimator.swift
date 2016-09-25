import Marshroute

final class RecursionAnimator: ModalNavigationTransitionsAnimator {
    fileprivate let animatedTransitioning = AnimatedTransitioningImpl()
    
    // MARK: - ModalNavigationTransitionsAnimator
    override func animatePerformingTransition(animationContext context: ModalNavigationPresentationAnimationContext) {
        targetModalPresentationStyle = .custom
        context.targetNavigationController.transitioningDelegate = animatedTransitioning
        super.animatePerformingTransition(animationContext: context)
    }
    
    override func animateUndoingTransition(animationContext context: ModalNavigationDismissalAnimationContext) {
        super.animateUndoingTransition(animationContext: context)
    }
}

private class AnimatedTransitioningImpl:
    NSObject,
    UIViewControllerTransitioningDelegate,
    UIViewControllerAnimatedTransitioning
{
    // MARK: - UIViewControllerTransitioningDelegate
    @objc func animationController(
        forPresented presented: UIViewController,
        presenting presentingController: UIViewController,
        source sourceController: UIViewController)
        -> UIViewControllerAnimatedTransitioning?
    {
        return self
    }
    
    @objc func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning?
    {
        return self
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    @objc func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?)
        -> TimeInterval
    {
        return 0.6
    }
    
    @objc func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else { return }
        
        if toViewController.isBeingPresented {
            animatePresentation(transitionContext)
        } else {
            animateDismissal(transitionContext)
        }
    }
    
    // MARK: - Private
    fileprivate func animatePresentation(_ transitionContext: UIViewControllerContextTransitioning)
    {
        guard let sourceViewController = transitionContext.viewController(forKey: .from)
            else { return }
        
        guard let targetViewController = transitionContext.viewController(forKey: .to)
            else { return }
        
        guard let sourceViewSnapshotImage = sourceViewController.view.screenshot()
            else { return }
        
        let sourceViewSnapshot = UIImageView(image: sourceViewSnapshotImage)
        
        let containerView = transitionContext.containerView
        
        let transitionDuration = self.transitionDuration(using: transitionContext)
        
        // Orientation bug fix
        // See: http://stackoverflow.com/a/20061872/351305
        targetViewController.view.frame = containerView.bounds
        sourceViewController.view.frame = containerView.bounds
        
        // Add black view below the container to hide `UITransitionView`s
        let blackView = UIView(frame: containerView.bounds)
        blackView.backgroundColor = .black
        containerView.superview?.insertSubview(blackView, belowSubview: containerView)
        
        // Add source view's snapshot to container
        containerView.addSubview(sourceViewSnapshot)
        
        // Hide source view
        sourceViewController.view.isHidden = true
        
        // Add destination view to container
        containerView.addSubview(targetViewController.view)
        
        // Move destination snapshot back in Z plane
        // Important: original transform3d is different from CATransform3DIdentity
        let originalTransform = targetViewController.view.layer.transform
        
        // Apply custom transform
        var perspectiveTransform = originalTransform
        perspectiveTransform.m34 = 1.0 / -1000.0
        perspectiveTransform = CATransform3DTranslate(perspectiveTransform, 0, 0, -100)
        targetViewController.view.layer.transform = perspectiveTransform
        
        // Start appearance transition for source controller
        // Because UIKit does not do this automatically
        sourceViewController.beginAppearanceTransition(false, animated: true)
        
        // Animate
        UIView.animateKeyframes(
            withDuration: transitionDuration,
            delay: 0.0,
            options: [.calculationModeCubic],
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                    sourceViewSnapshot.frame = self.frameBelowView(containerView)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.8, animations: {
                    targetViewController.view.layer.transform = originalTransform
                })
            },
            completion: { _ in
                // Release the black view
                blackView.removeFromSuperview()
                
                // Release the snapshot
                sourceViewSnapshot.removeFromSuperview()
                
                // Show the source view
                sourceViewController.view.isHidden = false
                
                // End appearance transition for source controller
                sourceViewController.endAppearanceTransition()
                
                // Finish transition
                transitionContext.completeTransition(true)
            }
        )
    }
    
    fileprivate func animateDismissal(_ transitionContext: UIViewControllerContextTransitioning)
    {
        guard let sourceViewController = transitionContext.viewController(forKey: .from)
            else { return }
        
        guard let targetViewController = transitionContext.viewController(forKey: .to)
            else { return }
        
        guard let targetViewSnapshotImage = targetViewController.view.screenshot()
            else { return }
        
        let targetViewSnapshot = UIImageView(image: targetViewSnapshotImage)
        
        let containerView = transitionContext.containerView
        
        let transitionDuration = self.transitionDuration(using: transitionContext)
        
        // Add black view below the container to hide `UITransitionView`s
        let blackView = UIView(frame: containerView.bounds)
        blackView.backgroundColor = .black
        containerView.superview?.insertSubview(blackView, belowSubview: containerView)
        
        // Add source view to container
        containerView.addSubview(sourceViewController.view)
        
        // Add target view's snapshot to container
        
        containerView.addSubview(targetViewSnapshot)
        
        // Hide target view
        targetViewController.view.isHidden = true
        
        // Move snapshot view below source view
        targetViewSnapshot.frame = frameBelowView(containerView)
        
        // Start appearance transition for destination controller
        // Because UIKit does not do this automatically
        targetViewController.beginAppearanceTransition(true, animated: true)
        
        // Animate
        UIView.animateKeyframes(
            withDuration: transitionDuration,
            delay: 0.0,
            options: [.calculationModeCubic],
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                    targetViewSnapshot.frame = containerView.bounds
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                    // Important: original transform3d is different from CATransform3DIdentity
                    var perspectiveTransform = sourceViewController.view.layer.transform
                    
                    perspectiveTransform.m34 = 1.0 / -1000.0
                    perspectiveTransform = CATransform3DTranslate(perspectiveTransform, 0, 0, -100)
                    sourceViewController.view.layer.transform = perspectiveTransform
                })
            },
            completion: { _ in
                // Release the black view
                blackView.removeFromSuperview()
                
                // Release the snapshot
                targetViewSnapshot.removeFromSuperview()
                
                // Show the target view
                targetViewController.view.isHidden = false
                
                // End appearance transition for destination controller
                targetViewController.endAppearanceTransition()
                
                // Finish transition
                transitionContext.completeTransition(true)
            }
        )
    }
    
    fileprivate func frameBelowView(_ relativeView: UIView)
        -> CGRect
    {
        return CGRect(x: 0, y: relativeView.frame.height, width: relativeView.frame.width, height: relativeView.frame.height)
    }
}

extension UIView {
    func screenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0);
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenshot
    }
}
