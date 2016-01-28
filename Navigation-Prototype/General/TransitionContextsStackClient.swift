import Foundation

class TransitionContextsStackClient {
    private let stack: TransitionContextsStack
    
    init(transitionContextsStack: TransitionContextsStack = TransitionContextsStack()) {
        stack = transitionContextsStack
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
    
    func chainedTransitionsHandlerForTransitionsHandler(transitionsHandler: TransitionsHandler)
        -> TransitionsHandler?
    {
        let chainedTransition = chainedTransitionForTransitionsHandler(transitionsHandler)
        return chainedTransition?.targetTransitionsHandler
    }
    
    func transitionWith(transitionId transitionId: TransitionId, forTransitionsHandler transitionsHandler: TransitionsHandler)
        -> RestoredTransitionContext?
    {
        if let restored = stack[transitionId]
            where restored.wasPerfromedByTransitionsHandler(transitionsHandler) {
                return restored
        }
        return nil
    }
    
    func allTransitionsForTransitionsHandler(transitionsHandler: TransitionsHandler)
        -> (chainedTransition: RestoredTransitionContext?, otherTransitions: [RestoredTransitionContext]?)
    {
        guard let first = stack.first where first.wasPerfromedByTransitionsHandler(transitionsHandler)
            else { return (nil, nil) }
        
        return transitionsAfter(
            transitionId: first.transitionId,
            forTransitionsHandler: transitionsHandler,
            includingTransitionWithId: true
        )
    }
    
    func transitionsAfter(
        transitionId transitionId: TransitionId,
        forTransitionsHandler transitionsHandler: TransitionsHandler,
        includingTransitionWithId: Bool)
        -> (chainedTransition: RestoredTransitionContext?, otherTransitions: [RestoredTransitionContext]?)
    {
        var chainedTransition: RestoredTransitionContext? = nil
        var otherTransitions: [RestoredTransitionContext]? = nil
        
        assert(
            transitionWith(transitionId: transitionId, forTransitionsHandler: transitionsHandler) != nil,
            "проверяйте заранее, что id перехода действительно относится к обработчику переходов"
        )
        
        if let last = lastTransitionForTransitionsHandler(transitionsHandler) {
            otherTransitions = [RestoredTransitionContext]()
            
            var notChainedTransitionId: TransitionId?
            
            if last.isChainedForTransitionsHandler(transitionsHandler) {
                chainedTransition = last
                notChainedTransitionId = stack.preceding(transitionId)?.transitionId
            }
            else {
                otherTransitions?.insert(last, atIndex: 0)
                notChainedTransitionId = last.transitionId
            }
            
            var didMatchId = transitionId == notChainedTransitionId
            
            while notChainedTransitionId != nil && !didMatchId {
                if let previous = stack.preceding(transitionId) {
                    notChainedTransitionId = previous.transitionId
                    
                    didMatchId = transitionId == notChainedTransitionId
                    
                    if !didMatchId || (didMatchId && includingTransitionWithId) {
                        otherTransitions?.insert(previous, atIndex: 0)
                    }
                }
                else { notChainedTransitionId = nil }
            }
        }
        
        return (chainedTransition, otherTransitions)
    }

    func deleteTransitionsAfter(
        transitionId transitionId: TransitionId,
        forTransitionsHandler transitionsHandler: TransitionsHandler,
        includingTransitionWithId: Bool)
    {
        let first = stack.popToPreceding(transitionId: transitionId)?.first
        assert(first == nil || first!.wasPerfromedByTransitionsHandler(transitionsHandler))
    }
    
    func appendTransition(
        context context: CompletedTransitionContext,
        forTransitionsHandler transitionsHandler: TransitionsHandler)
    {
        if context.sourceTransitionsHandler === transitionsHandler {
            stack.append(context)
        }
    }
}

// MARK: - heplers
private extension TransitionContextsStackClient {
    func lastTransitionForTransitionsHandler(transitionsHandler: TransitionsHandler)
        -> RestoredTransitionContext?
    {
        if let last = stack.last
            where last.wasPerfromedByTransitionsHandler(transitionsHandler) {
                return last
        }
        return nil
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

