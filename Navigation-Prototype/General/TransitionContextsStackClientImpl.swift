import Foundation

class TransitionContextsStackClientImpl {
    private let stack: TransitionContextsStack
    
    init(transitionContextsStack: TransitionContextsStack = TransitionContextsStackImpl()) {
        stack = transitionContextsStack
    }
}

extension TransitionContextsStackClientImpl: TransitionContextsStackClient {
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
    
    func transitionWith(
        transitionId transitionId: TransitionId,
        forTransitionsHandler transitionsHandler: TransitionsHandler)
        -> RestoredTransitionContext?
    {
        if let restored = stack[transitionId]
            where restored.wasPerfromedByTransitionsHandler(transitionsHandler) {
                return restored
        }
        return nil
    }
    
    func allTransitionsForTransitionsHandler(transitionsHandler: TransitionsHandler)
        -> (chainedTransition: RestoredTransitionContext?, pushTransitions: [RestoredTransitionContext]?)
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
        -> (chainedTransition: RestoredTransitionContext?, pushTransitions: [RestoredTransitionContext]?)
    {
        guard transitionWith(transitionId: transitionId, forTransitionsHandler: transitionsHandler) != nil
            else { return (nil, nil) }
        
        guard let last = lastTransitionForTransitionsHandler(transitionsHandler)
            else { return (nil, nil) }
        
        var didMatchId = transitionId == last.transitionId
        guard !didMatchId || (didMatchId && includingTransitionWithId)
            else { return (nil, nil) }
        
        var chainedTransition: RestoredTransitionContext? = nil
        var pushTransitions = [RestoredTransitionContext]()
            
        var loopTransitionId: TransitionId? = last.transitionId
        
        // только последний переход может не push-переходом (описывать модальное окно или поповер)
        if last.isChainedForTransitionsHandler(transitionsHandler) {
            chainedTransition = last
        }
        else {
            pushTransitions.insert(last, atIndex: 0)
            loopTransitionId = last.transitionId
        }
        
        // идем по push-переходам, кладем в массив в историческом порядке
        while loopTransitionId != nil && !didMatchId {
            if let previous = stack.preceding(transitionId: loopTransitionId!) {
                loopTransitionId = previous.transitionId
                
                didMatchId = transitionId == loopTransitionId
                
                if !didMatchId || (didMatchId && includingTransitionWithId) {
                    pushTransitions.insert(previous, atIndex: 0)
                }
            }
            else { loopTransitionId = nil }
        }
        
        return (chainedTransition, pushTransitions)
    }

    func deleteTransitionsAfter(
        transitionId transitionId: TransitionId,
        forTransitionsHandler transitionsHandler: TransitionsHandler,
        includingTransitionWithId: Bool)
    {
        var lastPopped = stack.popTo(transitionId: transitionId)?.first
        
        if includingTransitionWithId {
            lastPopped = stack.popLast()
        }
        assert(lastPopped == nil || lastPopped!.wasPerfromedByTransitionsHandler(transitionsHandler))
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
private extension TransitionContextsStackClientImpl {
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

