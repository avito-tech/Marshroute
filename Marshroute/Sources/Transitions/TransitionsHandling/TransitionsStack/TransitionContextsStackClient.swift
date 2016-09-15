/// Удобный клиент для работы с TransitionContextsStack.
/// Используется TransitionsCoordinator'ом, чтобы искать самого последнего TransitionsHandler'а в цепочке
public protocol TransitionContextsStackClient: class {
    func lastTransitionForTransitionsHandler(_ transitionsHandler: TransitionsHandler)
        -> RestoredTransitionContext?
    
    func chainedTransitionForTransitionsHandler(_ transitionsHandler: TransitionsHandler)
        -> RestoredTransitionContext?

    func chainedTransitionsHandlerBoxForTransitionsHandler(_ transitionsHandler: TransitionsHandler)
        -> RestoredTransitionTargetTransitionsHandlerBox?

    func transitionBefore(
        transitionId: TransitionId,
        forTransitionsHandler transitionsHandler: TransitionsHandler)
        -> RestoredTransitionContext?
    
    func transitionWith(
        transitionId: TransitionId,
        forTransitionsHandler transitionsHandler: TransitionsHandler)
        -> RestoredTransitionContext?
    
    func allTransitionsForTransitionsHandler(_ transitionsHandler: TransitionsHandler)
        -> (chainedTransition: RestoredTransitionContext?, pushTransitions: [RestoredTransitionContext]?)
    
    func transitionsAfter(
        transitionId: TransitionId,
        forTransitionsHandler transitionsHandler: TransitionsHandler,
        includingTransitionWithId: Bool)
        -> (chainedTransition: RestoredTransitionContext?, pushTransitions: [RestoredTransitionContext]?)

    func deleteTransitionsAfter(
        transitionId: TransitionId,
        forTransitionsHandler transitionsHandler: TransitionsHandler,
        includingTransitionWithId: Bool)
        -> Bool
    
    func appendTransition(
        context: CompletedTransitionContext,
        forTransitionsHandler transitionsHandler: TransitionsHandler)
        -> Bool
}
