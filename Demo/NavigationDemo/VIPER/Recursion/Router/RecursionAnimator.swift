import AvitoNavigation

final class RecursionAnimator: ModalNavigationTransitionsAnimator {
    private let animatedTransitioning = AnimatedTransitioningImpl()
    
    // MARK: - ModalNavigationTransitionsAnimator
    override func animatePerformingTransition(animationContext context: ModalNavigationPresentationAnimationContext) {
        targetModalPresentationStyle = .Custom
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
    @objc func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController: UIViewController,
        sourceController: UIViewController)
        -> UIViewControllerAnimatedTransitioning?
    {
        return self
    }
    
    @objc func animationControllerForDismissedController(dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning?
    {
        return self
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    @objc func transitionDuration(transitionContext: UIViewControllerContextTransitioning?)
        -> NSTimeInterval
    {
        return 0.6
    }
    
    @objc func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
            else { return }
        
        if toViewController.isBeingPresented() {
            animatePresentation(transitionContext)
        } else {
            animateDismissal(transitionContext)
        }
    }
    
    // MARK: - Private
    private func animatePresentation(transitionContext: UIViewControllerContextTransitioning)
    {
        guard let sourceViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
            else { return }
        
        guard let targetViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
            else { return }
        
        guard let containerView = transitionContext.containerView()
            else { return }
        
        let transitionDuration = self.transitionDuration(transitionContext)
        
        // Orientation bug fix
        // See: http://stackoverflow.com/a/20061872/351305
        targetViewController.view.frame = containerView.bounds
        sourceViewController.view.frame = containerView.bounds
        
        // Add black view below the container to hide `UITransitionView`s
        let blackView = UIView(frame: containerView.bounds)
        blackView.backgroundColor = .blackColor()
        containerView.superview?.insertSubview(blackView, belowSubview: containerView)
        
        // Add source view's snapshot to container
        let sourceViewSnapshot = sourceViewController.view.snapshotViewAfterScreenUpdates(false)
        containerView.addSubview(sourceViewSnapshot)
        
        // Hide source view
        sourceViewController.view.hidden = true
        
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
        UIView.animateKeyframesWithDuration(
            transitionDuration,
            delay: 0.0,
            options: [.CalculationModeCubic],
            animations: {
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1.0, animations: {
                    sourceViewSnapshot.frame = self.frameBelowView(containerView)
                })
                
                UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: 0.8, animations: {
                    targetViewController.view.layer.transform = originalTransform
                })
            },
            completion: { _ in
                // Release the black view
                blackView.removeFromSuperview()
                
                // Release the snapshot
                sourceViewSnapshot.removeFromSuperview()
                
                // Show the source view
                sourceViewController.view.hidden = false
                
                // End appearance transition for source controller
                sourceViewController.endAppearanceTransition()
                
                // Finish transition
                transitionContext.completeTransition(true)
            }
        )
    }
    
    private func animateDismissal(transitionContext: UIViewControllerContextTransitioning)
    {
        guard let sourceViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
            else { return }
        
        guard let targetViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
            else { return }
        
        guard let containerView = transitionContext.containerView()
            else { return }
        
        let transitionDuration = self.transitionDuration(transitionContext)
        
        // Add black view below the container to hide `UITransitionView`s
        let blackView = UIView(frame: containerView.bounds)
        blackView.backgroundColor = .blackColor()
        containerView.superview?.insertSubview(blackView, belowSubview: containerView)
        
        // Add source view to container
        containerView.addSubview(sourceViewController.view)
        
        // Add target view's snapshot to container
        let targetViewSnapshot = targetViewController.view.snapshotViewAfterScreenUpdates(false)
        containerView.addSubview(targetViewSnapshot)
        
        // Hide target view
        targetViewController.view.hidden = true
        
        // Move snapshot view below source view
        targetViewSnapshot.frame = frameBelowView(containerView)
        
        // Start appearance transition for destination controller
        // Because UIKit does not do this automatically
        targetViewController.beginAppearanceTransition(true, animated: true)
        
        // Animate
        UIView.animateKeyframesWithDuration(
            transitionDuration,
            delay: 0.0,
            options: [.CalculationModeCubic],
            animations: {
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1.0, animations: {
                    targetViewSnapshot.frame = containerView.bounds
                })
                
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1.0, animations: {
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
                targetViewController.view.hidden = false
                
                // End appearance transition for destination controller
                targetViewController.endAppearanceTransition()
                
                // Finish transition
                transitionContext.completeTransition(true)
            }
        )
    }
    
    private func frameBelowView(relativeView: UIView)
        -> CGRect
    {
        return CGRect(x: 0, y: relativeView.frame.height, width: relativeView.frame.width, height: relativeView.frame.height)
    }
}