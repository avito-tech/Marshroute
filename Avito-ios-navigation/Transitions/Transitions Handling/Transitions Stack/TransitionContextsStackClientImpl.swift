final public class TransitionContextsStackClientImpl: TransitionContextsStackClient {
    private let stack: TransitionContextsStack
    
    public init(transitionContextsStack: TransitionContextsStack = TransitionContextsStackImpl()) {
        stack = transitionContextsStack
    }
    
    // MARK: - TransitionContextsStackClient
    public func lastTransitionForTransitionsHandler(transitionsHandler: TransitionsHandler)
        -> RestoredTransitionContext?
    {
        if let last = stack.last
            where last.wasPerfromedByTransitionsHandler(transitionsHandler) {
                return last
        }
        return nil
    }
    
    public func chainedTransitionForTransitionsHandler(transitionsHandler: TransitionsHandler)
        -> RestoredTransitionContext?
    {
        if let last = lastTransitionForTransitionsHandler(transitionsHandler)
            where last.isChainedForTransitionsHandler(transitionsHandler) {
                return last
        }
        return nil
    }
    
    public func chainedTransitionsHandlerBoxForTransitionsHandler(transitionsHandler: TransitionsHandler)
        -> RestoredTransitionTargetTransitionsHandlerBox?
    {
        let chainedTransition = chainedTransitionForTransitionsHandler(transitionsHandler)
        return chainedTransition?.targetTransitionsHandlerBox
    }
    
    public func transitionWith(
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
    
    public func allTransitionsForTransitionsHandler(transitionsHandler: TransitionsHandler)
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
    
    public func transitionsAfter(
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
            else { loopTransitionId = nil } // останавливаем цикл
        }
        
        return (chainedTransition, pushTransitions)
    }

    public func deleteTransitionsAfter(
        transitionId transitionId: TransitionId,
        forTransitionsHandler transitionsHandler: TransitionsHandler,
        includingTransitionWithId: Bool)
        -> Bool
    {
        guard let first = stack.first where first.wasPerfromedByTransitionsHandler(transitionsHandler)
            else { return false }
        
        guard let _ = transitionWith(transitionId: transitionId, forTransitionsHandler: transitionsHandler)
            else { return false }
        
        if includingTransitionWithId {
            stack.popTo(transitionId: transitionId)?.first
            return (stack.popLast() != nil)
        }
        else {
            return (stack.popTo(transitionId: transitionId)?.first != nil)
        }
    }
    
    public func appendTransition(
        context context: CompletedTransitionContext,
        forTransitionsHandler transitionsHandler: TransitionsHandler)
        -> Bool
    {
        guard context.isMatchingTransitionsHandler(transitionsHandler)
            else { return false }
        
        stack.append(context)
        return true
    }
}

// MARK: - CompletedTransitionContext helpers
private extension CompletedTransitionContext {
    func isMatchingTransitionsHandler(transitionsHandler: TransitionsHandler)
        -> Bool
    {
        let result = (sourceTransitionsHandler === transitionsHandler)
        return result
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
        let result = (targetTransitionsHandlerBox.unbox() !== transitionsHandler)
        return result
    }
}