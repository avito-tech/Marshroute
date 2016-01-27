/// Стэк, который хранит CompletedTransitionContext, а возвращает RestoredTransitionContext
class TransitionContextsStack {
    private var transitionsStack = [CompletedTransitionContext]()
    
    func append(context: CompletedTransitionContext)
    {
        updateTransitionsStack()
        transitionsStack.append(context)
    }
    
    var last: RestoredTransitionContext?
    {
        updateTransitionsStack()
        let last = transitionsStack.last
        let restored = RestoredTransitionContext(completedTransition: last)
        return restored
    }
    
    func popLast()
        -> RestoredTransitionContext?
    {
        updateTransitionsStack()
        let last = transitionsStack.popLast()
        let restored = RestoredTransitionContext(completedTransition: last)
        return restored
    }
    
    subscript (transitionId: TransitionId)
        -> RestoredTransitionContext?
    {
        updateTransitionsStack()
        let index = indexOfCompletedTransition(transitionId: transitionId)
        let restored: RestoredTransitionContext? = self[index]
        return restored
    }
    
    func popTo(transitionId transitionId: TransitionId)
        -> [RestoredTransitionContext]?
    {
        updateTransitionsStack()
        let index = indexOfCompletedTransition(transitionId: transitionId)
        let result = popTo(index: index)
        return result
    }
    
    func lastPreceding(transitionId: TransitionId)
        -> RestoredTransitionContext?
    {
        updateTransitionsStack()
        let index = indexOfCompletedTransition(transitionId: transitionId)
        let restored: RestoredTransitionContext? = self[index]
        return restored
    }

    func popToLastPreceding(transitionId transitionId: TransitionId)
        -> [RestoredTransitionContext]?
    {
        updateTransitionsStack()
        let index = indexOfCompletedTransitionPreceding(transitionId: transitionId)
        let result = popTo(index: index)
        return result
    }
    
    func removeAll()
    {
        transitionsStack.removeAll()
    }

}

// MARK: - private
private extension TransitionContextsStack {
    /**
     Убирает из стека те записи о совершенных переходах, в которых контроллер,
     на который осуществлялся переход, уже освобожден
     */
    func updateTransitionsStack()
    {
        let transitionsStack = self.transitionsStack.filter({ !$0.isZombie })
        self.transitionsStack = transitionsStack
    }
    
    func indexOfCompletedTransition(transitionId transitionId: TransitionId)
        -> Int?
    {
        let transitionIds = transitionsStack.map() { $0.transitionId }
        if let index = transitionIds.indexOf({ $0 == transitionId }) where index < transitionsStack.count {
            return index
        }
        return nil
    }
    
    func indexOfCompletedTransitionPreceding(transitionId transitionId: TransitionId)
        -> Int?
    {
        let transitionIds = transitionsStack.map() { $0.transitionId }
        if let index = transitionIds.indexOf({ $0 == transitionId }) where index < transitionsStack.count {
            return index > 0 ? index - 1 : nil
        }
        return nil
    }
    
    private subscript (index: Int?)
        -> CompletedTransitionContext?
    {
        if let index = index where index < transitionsStack.count {
            return transitionsStack[index]
        }
        return nil
    }
    
    private subscript (index: Int?)
        -> RestoredTransitionContext?
    {
        let completed: CompletedTransitionContext? = self[index]
        let restored = RestoredTransitionContext(completedTransition: completed)
        return restored
    }
    
    private func popTo(index index: Int?)
        -> [RestoredTransitionContext]?
    {
        guard let index = index where index < transitionsStack.count
            else { return nil }
        
        var result = [RestoredTransitionContext]()
        
        for _ in index ..< transitionsStack.count {
            if let last = popLast() {
                result.insert(last, atIndex: 0)
            }
        }
        
        return result
    }
}