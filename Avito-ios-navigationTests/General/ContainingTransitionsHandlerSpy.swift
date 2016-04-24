final class ContainingTransitionsHandlerSpy: ContainingTransitionsHandler
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
    
    // MARK: - TransitionsHandlerContainer
    var allTransitionsHandlersCalled = false
    var allTransitionsHandlersStub: [AnimatingTransitionsHandler]!
    override var allTransitionsHandlers: [AnimatingTransitionsHandler]? {
        allTransitionsHandlersCalled = true
        return allTransitionsHandlersStub
    }
    
    var visibleTransitionsHandlersCalled = false
    var visibleTransitionsHandlersStub: [AnimatingTransitionsHandler]!
    override var visibleTransitionsHandlers: [AnimatingTransitionsHandler]? {
        visibleTransitionsHandlersCalled = true
        return visibleTransitionsHandlersStub
    }
}