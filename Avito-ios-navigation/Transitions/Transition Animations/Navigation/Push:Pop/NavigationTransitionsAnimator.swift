public class NavigationTransitionsAnimator: TransitionsAnimator
{
    public var shouldAnimate = true

    // MARK: - Init
    public init() {}

    // MARK: - TransitionsAnimator
    public func animatePerformingTransition(animationContext context: PushAnimationContext)
    {
        context.navigationController.pushViewController(
            context.targetViewController,
            animated: shouldAnimate
        )
        shouldAnimate = true
    }

    public func animateUndoingTransition(animationContext context: PopAnimationContext)
    {
        context.navigationController.popToViewController(
            context.targetViewController,
            animated: shouldAnimate
        )
        shouldAnimate = true
    }
}