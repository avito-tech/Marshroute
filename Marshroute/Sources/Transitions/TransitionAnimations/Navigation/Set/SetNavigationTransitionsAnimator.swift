/// Аниматор, выполняющий первоначальное проставление корневого контроллера в UINavigationController'е
open class SetNavigationTransitionsAnimator: ResetTransitionsAnimator
{
    open var shouldAnimate = true

    // MARK: - Init
    public init() {}

    // MARK: - ResetTransitionsAnimator
    open func animateResettingWithTransition(animationContext context: SettingNavigationAnimationContext)
    {
        context.navigationController.setViewControllers(
            [context.rootViewController],
            animated: shouldAnimate
        )
        shouldAnimate = true
    }
}
