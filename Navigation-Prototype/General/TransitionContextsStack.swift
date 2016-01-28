/// Стэк, который хранит CompletedTransitionContext, а возвращает RestoredTransitionContext
class TransitionContextsStack {
    private var stack = [CompletedTransitionContext]()
    
    func append(context: CompletedTransitionContext)
    {
        updateStack()
        stack.append(context)
    }
    
    var first: RestoredTransitionContext? {
        let result: RestoredTransitionContext? = self[0]
        return result
    }
        
    var last: RestoredTransitionContext?
    {
        updateStack()
        let last = stack.last
        let restored = RestoredTransitionContext(completedTransition: last)
        return restored
    }
    
    func popLast()
        -> RestoredTransitionContext?
    {
        updateStack()
        let last = stack.popLast()
        let restored = RestoredTransitionContext(completedTransition: last)
        return restored
    }
    
    subscript (transitionId: TransitionId)
        -> RestoredTransitionContext?
    {
        updateStack()
        let index = indexOfCompletedTransition(transitionId: transitionId)
        let restored: RestoredTransitionContext? = self[index]
        return restored
    }
    
    func popToPreceding(transitionId transitionId: TransitionId)
        -> [RestoredTransitionContext]?
    {
        updateStack()
        let index = indexOfCompletedTransitionPreceding(transitionId: transitionId)
        ?? indexOfCompletedTransition(transitionId: transitionId)
        let result = popTo(index: index)
        return result
    }
    
    func preceding(transitionId: TransitionId)
        -> RestoredTransitionContext?
    {
        updateStack()
        let index = indexOfCompletedTransitionPreceding(transitionId: transitionId)
        let restored: RestoredTransitionContext? = self[index]
        return restored
    }
    
    func removeAll()
    {
        stack.removeAll()
    }
}

// MARK: - private
private extension TransitionContextsStack {
    /**
     Убирает из стека те записи о совершенных переходах, в которых контроллер,
     на который осуществлялся переход, уже освобожден
     */
    func updateStack()
    {
        let stack = self.stack.filter({ !$0.isZombie })
        self.stack = stack
    }
    
    func indexOfCompletedTransition(transitionId transitionId: TransitionId)
        -> Int?
    {
        let transitionIds = stack.map() { $0.transitionId }
        if let index = transitionIds.indexOf({ $0 == transitionId })
            where index < stack.count {
                return index
        }
        return nil
    }
    
    func indexOfCompletedTransitionPreceding(transitionId transitionId: TransitionId)
        -> Int?
    {
        if let index = indexOfCompletedTransition(transitionId: transitionId)
            where index > 0 {
                return index - 1
        }
        return nil
    }
    
    subscript (index: Int?)
        -> CompletedTransitionContext?
    {
        if let index = index where index < stack.count {
            return stack[index]
        }
        return nil
    }
    
    subscript (index: Int?)
        -> RestoredTransitionContext?
    {
        let completed: CompletedTransitionContext? = self[index]
        let restored = RestoredTransitionContext(completedTransition: completed)
        return restored
    }
    
    func popTo(index index: Int?)
        -> [RestoredTransitionContext]?
    {
        guard let index = index where index < stack.count
            else { return nil }
        
        var result = [RestoredTransitionContext]()
        
        for _ in index ..< stack.count {
            if let last = popLast() {
                result.insert(last, atIndex: 0)
            }
            else { break }
        }
        
        return result
    }
}