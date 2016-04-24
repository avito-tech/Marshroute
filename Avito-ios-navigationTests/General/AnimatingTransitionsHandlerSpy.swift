final class AnimatingTransitionsHandlerSpy: AnimatingTransitionsHandler
{
    // MARK: - TransitionsHandler
    var performTransitionCalled = false
    var perFormTransitionContextParameter: PresentationTransitionContext!
    override func performTransition(context context: PresentationTransitionContext) {
        performTransitionCalled = true
        perFormTransitionContextParameter = context
    }
    
    var undoTransitionsAfterCalled = false
    var undoTransitionsAfterTransitionIdParameter: TransitionId!
    override func undoTransitionsAfter(transitionId transitionId: TransitionId) {
        undoTransitionsAfterCalled = true
        undoTransitionsAfterTransitionIdParameter = transitionId
    }
    
    var undoTransitionWithCalled = false
    var undoTransitionWithTransitionIdParameter: TransitionId!
    override func undoTransitionWith(transitionId transitionId: TransitionId) {
        undoTransitionWithCalled = true
        undoTransitionWithTransitionIdParameter = transitionId
    }
    
    var undoAllChainedTransitionsCalled = false
    override func undoAllChainedTransitions() {
        undoAllChainedTransitionsCalled = true
    }
    
    var undoAllTransitionsCalled = false
    override func undoAllTransitions() {
        undoAllTransitionsCalled = true
    }
    
    var resetWithTransitionCalled = false
    var resetWithTransitionContextParameter: ResettingTransitionContext!
    override func resetWithTransition(context context: ResettingTransitionContext) {
        resetWithTransitionCalled = true
        resetWithTransitionContextParameter = context
    }
    
    // MARK: - TransitionAnimationsLauncher
    var launchPresentationAnimationCalled = false
    var launchPresentationAnimationLaunchingContextBoxParameter: PresentationAnimationLaunchingContextBox!
    override func launchPresentationAnimation(
        inout launchingContextBox launchingContextBox: PresentationAnimationLaunchingContextBox) {
        launchPresentationAnimationCalled = true
        launchPresentationAnimationLaunchingContextBoxParameter = launchingContextBox
    }
    
    var launchDismissalAnimationCalled = false
    var launchDismissalAnimationLaunchingContextBoxParameter: DismissalAnimationLaunchingContextBox!
    override func launchDismissalAnimation(
        launchingContextBox launchingContextBox: DismissalAnimationLaunchingContextBox) {
        launchDismissalAnimationCalled = true
        launchDismissalAnimationLaunchingContextBoxParameter = launchingContextBox
    }
    
    var launchResettingAnimationCalled = false
    var launchResettingAnimationLaunchingContextBoxParameter: ResettingAnimationLaunchingContextBox!
    override func launchResettingAnimation(
        inout launchingContextBox launchingContextBox: ResettingAnimationLaunchingContextBox) {
        launchResettingAnimationCalled = true
        launchResettingAnimationLaunchingContextBoxParameter = launchingContextBox
    }
}