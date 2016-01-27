import Foundation

class TransitionContextsStackClient {
    let stack: TransitionContextsStack
    
    init(transitionContextsStack: TransitionContextsStack = TransitionContextsStack()) {
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
        if let last = lastTransitionForTransitionsHandler(transitionsHandler)
            where (last.targetTransitionsHandler !== transitionsHandler) && (last.sourceTransitionsHandler === transitionsHandler) {
            return last
        }
        return nil
    }
    
    func lastTransitionForTransitionsHandler(transitionsHandler: TransitionsHandler)
        -> RestoredTransitionContext?
    {
        if let last = stack.last where last.sourceTransitionsHandler === transitionsHandler {
            return last
        }
        return nil
    }
    
    func transitionWithId(transitionId: TransitionId, forTransitionsHandler transitionsHandler: TransitionsHandler)
        -> RestoredTransitionContext?
    {
        if let restored = stack[transitionId] where restored.sourceTransitionsHandler === transitionsHandler {
            return restored
        }
        return nil
    }
    
    func transitionsTil(transitionId transitionId: TransitionId, forTransitionsHandler transitionsHandler: TransitionsHandler)
        -> (chainedTransition: RestoredTransitionContext?, otherTransitions: [RestoredTransitionContext])
    {

    }
    
    func transitionsPreceding(transitionId transitionId: TransitionId, forTransitionsHandler transitionsHandler: TransitionsHandler)
        -> (chainedTransition: RestoredTransitionContext?, otherTransitions: [RestoredTransitionContext])
    {
        let restored = stack
    }
}