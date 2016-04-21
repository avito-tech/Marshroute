public class ResetTransitionsAnimatorImpl: ResetTransitionsAnimator
{
    public var shouldAnimate = true

    // MARK: - Init
    public init() {}

    // MARK: - ResetTransitionsAnimator
    public func animateResettingWithTransition(animationContext context: ResettingAnimationContext)
    {
        context.navigationController.setViewControllers(
            [context.targetViewController],
            animated: shouldAnimate
        )
        shouldAnimate = true
    }
}