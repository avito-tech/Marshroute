/// Аниматор, выполняющий замену корневого контроллера в UINavigationController'е
open class ResetNavigationTransitionsAnimator: ResetTransitionsAnimator
{
    open var shouldAnimate = true

    // MARK: - Init
    public init() {}

    // MARK: - ResetTransitionsAnimator
    open func animateResettingWithTransition(animationContext context: ResettingNavigationAnimationContext)
    {
        context.navigationController.setViewControllers(
            [context.rootViewController],
            animated: shouldAnimate
        )
        shouldAnimate = true
    }
}
