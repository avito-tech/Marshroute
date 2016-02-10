/// Базовый класс для аниматоров с участием UINavigationController
class BaseNavigationTransitionsAnimator: TransitionsAnimator {
    func animatePerformingTransition(animationContext context: NavigationAnimationContext)
    {
        assert(false, "must be overriden")
    }
    
    func animateUndoingTransition(animationContext context: NavigationAnimationContext)
    {
        assert(false, "must be overriden")
    }
    
    func animateResettingWithTransition(animationContext context: NavigationAnimationContext)
    {
        switch context.animationStyle {
        case .Modal:
            assert(false, "must never be called"); break
        default:
            assert(false, "must be overriden"); break
        }
    }
}