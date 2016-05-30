/// Аниматор, выполняющий замену корневого контроллера в UINavigationController'е
public class ResetNavigationTransitionsAnimator: ResetTransitionsAnimator
{
    public var shouldAnimate = true

    // MARK: - Init
    public init() {}

    // MARK: - ResetTransitionsAnimator
    public func animateResettingWithTransition(animationContext context: ResettingNavigationAnimationContext)
    {
        context.navigationController.setViewControllers(
            [context.rootViewController],
            animated: shouldAnimate
        )
        shouldAnimate = true
    }
}