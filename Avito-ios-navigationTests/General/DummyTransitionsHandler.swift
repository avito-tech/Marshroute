final class DummyTransitionsHandler: AnimatingTransitionsHandler {
    override func performTransition(context context: PresentationTransitionContext) {}
    override func undoTransitionsAfter(transitionId transitionId: TransitionId) {}
    override func undoTransitionWith(transitionId transitionId: TransitionId) {}
    override func undoAllChainedTransitions() {}
    override func undoAllTransitions() {}
    override func resetWithTransition(context context: ResettingTransitionContext) {}
    
    override func launchPresentationAnimation(inout launchingContextBox launchingContextBox: PresentationAnimationLaunchingContextBox) {}
    override func launchDismissalAnimation(launchingContextBox launchingContextBox: DismissalAnimationLaunchingContextBox) {}
    override func launchResettingAnimation(inout launchingContextBox launchingContextBox: ResettingAnimationLaunchingContextBox) {}
    
    init() {
        let coodinator = TransitionsCoordinatorImpl()
        super.init(transitionsCoordinator: coodinator)
    }
}