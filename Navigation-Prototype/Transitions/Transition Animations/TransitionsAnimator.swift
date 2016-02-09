/// Анимирование переходов
protocol TransitionsAnimator: class {
    func animatePerformingTransition(animationContext context: TransitionAnimationContext)
    func animateUndoingTransition(animationContext context: TransitionAnimationContext)
    func animateResettingWithTransition(animationContext context: TransitionAnimationContext)
}

extension TransitionsAnimator where Self: NavigationTransitionsAnimator {
    func animatePerformingTransition(animationContext context: TransitionAnimationContext) {
        if let context = context as? NavigationAnimationContext {
            animatePerformingNavigationTransition(animationContext: context)
        }
    }
    
    func animateUndoingTransition(animationContext context: TransitionAnimationContext) {
        if let context = context as? NavigationAnimationContext {
            animateUndoingNavigationTransition(animationContext: context)
        }
    }
    
    func animateResettingWithTransition(animationContext context: TransitionAnimationContext) {
        if let context = context as? NavigationAnimationContext {
            animateResettingWithNavigationTransition(animationContext: context)
        }
    }
}

extension TransitionsAnimator where Self: PopoverTransitionsAnimator {
    func animatePerformingTransition(animationContext context: TransitionAnimationContext) {
        if let context = context as? PopoverAnimationContext {
            animatePerformingPopoverTransition(animationContext: context)
        }
    }
    
    func animateUndoingTransition(animationContext context: TransitionAnimationContext) {
        if let context = context as? PopoverAnimationContext {
            animateUndoingPopoverTransition(animationContext: context)
        }
    }
    
    func animateResettingWithTransition(animationContext context: TransitionAnimationContext) {
        if let context = context as? PopoverAnimationContext {
            animateResettingWithPopoverTransition(animationContext: context)
        }
    }
}