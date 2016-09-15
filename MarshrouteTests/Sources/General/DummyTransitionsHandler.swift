final class DummyAnimatingTransitionsHandler: AnimatingTransitionsHandler {
    override func performTransition(context: PresentationTransitionContext) {}
    override func undoTransitionsAfter(transitionId: TransitionId) {}
    override func undoTransitionWith(transitionId: TransitionId) {}
    override func undoAllChainedTransitions() {}
    override func undoAllTransitions() {}
    override func resetWithTransition(context: ResettingTransitionContext) {}
    
    override func launchPresentationAnimation(launchingContextBox: inout PresentationAnimationLaunchingContextBox) {}
    override func launchDismissalAnimation(launchingContextBox: DismissalAnimationLaunchingContextBox) {}
    override func launchResettingAnimation(launchingContextBox: inout ResettingAnimationLaunchingContextBox) {}
    
    init() {
        let coodinator = TransitionsCoordinatorImpl()
        super.init(transitionsCoordinator: coodinator)
    }
}
