/// Аниматор, выполняющий первоначальное проставление корневого контроллера в UINavigationController'е
public class SetNavigationTransitionsAnimator: ResetTransitionsAnimator
{
    public var shouldAnimate = true

    // MARK: - Init
    public init() {}

    // MARK: - ResetTransitionsAnimator
    public func animateResettingWithTransition(animationContext context: SettingNavigationAnimationContext)
    {
        context.navigationController.setViewControllers(
            [context.rootViewController],
            animated: shouldAnimate
        )
        shouldAnimate = true
    }
}