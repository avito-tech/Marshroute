/// Аниматор, выполняющий push-pop переходы
open class NavigationTransitionsAnimator: TransitionsAnimator
{
    open var shouldAnimate = true

    // MARK: - Init
    public init() {}

    // MARK: - TransitionsAnimator
    open func animatePerformingTransition(animationContext context: PushAnimationContext)
    {
        context.navigationController.pushViewController(
            context.targetViewController,
            animated: shouldAnimate
        )
        shouldAnimate = true
    }

    open func animateUndoingTransition(animationContext context: PopAnimationContext)
    {
        context.navigationController.popToViewController(
            context.targetViewController,
            animated: shouldAnimate
        )
        shouldAnimate = true
    }
}
