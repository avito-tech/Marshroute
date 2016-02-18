import XCTest

class DummyTransitionsHandler: AnimatingTransitionsHandler {
    override func performTransition(context context: ForwardTransitionContext) {}
    override func undoTransitionsAfter(transitionId transitionId: TransitionId) {}
    override func undoTransitionWith(transitionId transitionId: TransitionId) {}
    override func undoAllChainedTransitions() {}
    override func undoAllTransitions() {}
    override func resetWithTransition(context context: ForwardTransitionContext) {}
    
    override func launchAnimationOfPerformingTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext) {}
    override func launchAnimationOfUndoingTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext) {}
    override func launchAnimationOfResettingWithTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext) {}
    
    init() {
        let coodinator = TransitionsCoordinatorImpl()
        super.init(transitionsCoordinator: coodinator)
    }
}