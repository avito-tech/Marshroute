/// Удобный клиент для работы с TransitionContextsStack.
/// Используется TransitionsCoordinator'ом, чтобы искать самого последнего TransitionsHandler'а в цепочке
public protocol TransitionContextsStackClient: class {
    func lastTransitionForTransitionsHandler(transitionsHandler: TransitionsHandler)
        -> RestoredTransitionContext?
    
    func chainedTransitionForTransitionsHandler(transitionsHandler: TransitionsHandler)
        -> RestoredTransitionContext?

    func chainedTransitionsHandlerBoxForTransitionsHandler(transitionsHandler: TransitionsHandler)
        -> RestoredTransitionTargetTransitionsHandlerBox?

    func transitionBefore(
        transitionId transitionId: TransitionId,
        forTransitionsHandler transitionsHandler: TransitionsHandler)
        -> RestoredTransitionContext?
    
    func transitionWith(
        transitionId transitionId: TransitionId,
        forTransitionsHandler transitionsHandler: TransitionsHandler)
        -> RestoredTransitionContext?
    
    func allTransitionsForTransitionsHandler(transitionsHandler: TransitionsHandler)
        -> (chainedTransition: RestoredTransitionContext?, pushTransitions: [RestoredTransitionContext]?)
    
    func transitionsAfter(
        transitionId transitionId: TransitionId,
        forTransitionsHandler transitionsHandler: TransitionsHandler,
        includingTransitionWithId: Bool)
        -> (chainedTransition: RestoredTransitionContext?, pushTransitions: [RestoredTransitionContext]?)

    func deleteTransitionsAfter(
        transitionId transitionId: TransitionId,
        forTransitionsHandler transitionsHandler: TransitionsHandler,
        includingTransitionWithId: Bool)
        -> Bool
    
    func appendTransition(
        context context: CompletedTransitionContext,
        forTransitionsHandler transitionsHandler: TransitionsHandler)
        -> Bool
}