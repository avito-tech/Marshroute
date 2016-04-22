import XCTest

class DummyTransitionsHandler: AnimatingTransitionsHandler {
    override func performTransition(context context: PresentationTransitionContext) {}
    override func undoTransitionsAfter(transitionId transitionId: TransitionId) {}
    override func undoTransitionWith(transitionId transitionId: TransitionId) {}
    override func undoAllChainedTransitions() {}
    override func undoAllTransitions() {}
    override func resetWithTransition(context context: ResettingTransitionContext) {}
    
    override func launchAnimationOfPerformingTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext) {}
    override func launchAnimationOfUndoingTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext) {}
    override func launchAnimationOfResettingWithTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext) {}
    
    init() {
        let coodinator = TransitionsCoordinatorImpl()
        super.init(transitionsCoordinator: coodinator)
    }
}