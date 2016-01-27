import Foundation

class TransitionContextsStackClient {
    let stack: TransitionContextsStack
    
    init(transitionContextsStack: TransitionContextsStack = TransitionContextsStack()) {
        stack = transitionContextsStack
    }
    
    func doesTransitionsHandlerHaveChainedTransitionHandlers(transitionsHandler: TransitionsHandler)
        -> Bool
    {
        let chainedTransitionsHandler = chainedTransitionsHandlerForTransitionsHandler(transitionsHandler)
        return chainedTransitionsHandler != nil
    }
    
    func chainedTransitionsHandlerForTransitionsHandler(transitionsHandler: TransitionsHandler)
        -> TransitionsHandler?
    {
        let chainedTransition = chainedTransitionForTransitionsHandler(transitionsHandler)
        return chainedTransition?.targetTransitionsHandler
    }
    
    func doesTransitionWithId(
        transitionId: TransitionId,
        belongToTransitionsHandler transitionsHandler: TransitionsHandler)
        -> Bool
    {
        let context = transitionWithId(transitionId, forTransitionsHandler: transitionsHandler)
        return context != nil
    }
    
    func transitionsAfter(transitionId transitionId: TransitionId, forTransitionsHandler transitionsHandler: TransitionsHandler)
        -> (chainedTransition: RestoredTransitionContext?, otherTransitions: [RestoredTransitionContext]?)
    {
        return transitionsAfter(
            transitionId: transitionId,
            forTransitionsHandler: transitionsHandler,
            includingTransitionId: false
        )
    }
    
    func transitionsAfterAndIncluding(transitionId transitionId: TransitionId, forTransitionsHandler transitionsHandler: TransitionsHandler)
        -> (chainedTransition: RestoredTransitionContext?, otherTransitions: [RestoredTransitionContext]?)
    {
        return transitionsAfter(
            transitionId: transitionId,
            forTransitionsHandler: transitionsHandler,
            includingTransitionId: true
        )
    }
    
}

// MARK: - heplers
private extension TransitionContextsStackClient {
    func transitionWithId(transitionId: TransitionId, forTransitionsHandler transitionsHandler: TransitionsHandler)
        -> RestoredTransitionContext?
    {
        if let restored = stack[transitionId]
            where restored.wasPerfromedByTransitionsHandler(transitionsHandler) {
                return restored
        }
        return nil
    }
    
    func chainedTransitionForTransitionsHandler(transitionsHandler: TransitionsHandler)
        -> RestoredTransitionContext?
    {
        if let last = lastTransitionForTransitionsHandler(transitionsHandler)
            where last.isChainedForTransitionsHandler(transitionsHandler) {
                return last
        }
        return nil
    }
    
    func lastTransitionForTransitionsHandler(transitionsHandler: TransitionsHandler)
        -> RestoredTransitionContext?
    {
        if let last = stack.last
            where last.wasPerfromedByTransitionsHandler(transitionsHandler) {
                return last
        }
        return nil
    }
    
    func transitionsAfter(
        transitionId transitionId: TransitionId,
        forTransitionsHandler transitionsHandler: TransitionsHandler,
        includingTransitionId including: Bool)
        -> (chainedTransition: RestoredTransitionContext?, otherTransitions: [RestoredTransitionContext]?)
    {
        var chainedTransition: RestoredTransitionContext? = nil
        var otherTransitions: [RestoredTransitionContext]? = nil
        
        assert(
            transitionWithId(transitionId, forTransitionsHandler: transitionsHandler) != nil,
            "проверяйте заранее, что id перехода действительно относится к обработчику переходов"
        )
        
        if let last = lastTransitionForTransitionsHandler(transitionsHandler) {
            otherTransitions = [RestoredTransitionContext]()
            
            var notChainedTransitionId: TransitionId?
            
            if last.isChainedForTransitionsHandler(transitionsHandler) {
                chainedTransition = last
                notChainedTransitionId = stack.lastPreceding(transitionId)?.transitionId
            }
            else {
                otherTransitions?.insert(last, atIndex: 0)
                notChainedTransitionId = last.transitionId
            }
            
            var didMatchId = transitionId == notChainedTransitionId
            
            while notChainedTransitionId != nil && !didMatchId {
                if let previous = stack.lastPreceding(transitionId) {
                    notChainedTransitionId = previous.transitionId

                    didMatchId = transitionId == notChainedTransitionId
                    
                    if !didMatchId || (didMatchId && including) {
                        otherTransitions?.insert(previous, atIndex: 0)
                    }
                }
                else { notChainedTransitionId = nil }
            }
        }
        
        return (chainedTransition, otherTransitions)
    }
}

// MARK: - RestoredTransitionContext helpers
private extension RestoredTransitionContext {
    func wasPerfromedByTransitionsHandler(transitionsHandler: TransitionsHandler)
        -> Bool
    {
        let result = (sourceTransitionsHandler === transitionsHandler)
        return result
    }
    
    func isChainedForTransitionsHandler(transitionsHandler: TransitionsHandler)
        -> Bool
    {
        let result = (targetTransitionsHandler !== transitionsHandler)
        return result
    }
}

