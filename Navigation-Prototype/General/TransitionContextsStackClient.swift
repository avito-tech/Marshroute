import Foundation

class TransitionContextsStackClient {
    let stack: TransitionContextsStack
    
    init(transitionContextsStack: TransitionContextsStack) {
        stack = transitionContextsStack
    }
    
    func chainedTransitionsHandlerForTransitionsHandler(transitionsHandler: TransitionsHandler)
        -> TransitionsHandler?
    {
        let chainedTransition = chainedTransitionForTransitionsHandler(transitionsHandler)
        return chainedTransition?.targetTransitionsHandler
    }
    
    func chainedTransitionForTransitionsHandler(transitionsHandler: TransitionsHandler)
        -> RestoredTransitionContext?
    {
        let last = lastTransitionForTransitionsHandler(transitionsHandler)
        return (last?.targetTransitionsHandler === transitionsHandler) ? last : nil
    }
    
    func lastTransitionForTransitionsHandler(transitionsHandler: TransitionsHandler)
        -> RestoredTransitionContext?
    {
        let last = stack.last
        assert(last == nil || last!.sourceTransitionsHandler === transitionsHandler)
        return last
    }
    
    func transitionWithId(transitionId: TransitionId)
        -> RestoredTransitionContext?
    {
        let restored = stack[transitionId]
        return restored
    }
    
    func transitionsTil(transitionId transitionId: TransitionId, forTransitionsHandler transitionsHandler: TransitionsHandler)
        -> (chainedTransition: RestoredTransitionContext?, otherTransitions: [RestoredTransitionContext])
    {
        let restored = stack.pre
    }
    
    func transitionsPreceding(transitionId transitionId: TransitionId, forTransitionsHandler transitionsHandler: TransitionsHandler)
        -> (chainedTransition: RestoredTransitionContext?, otherTransitions: [RestoredTransitionContext])
    {
        let restored = stack.
    }
}