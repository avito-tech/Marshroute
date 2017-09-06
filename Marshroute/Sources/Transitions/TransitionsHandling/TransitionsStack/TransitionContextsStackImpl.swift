public final class TransitionContextsStackImpl: TransitionContextsStack {
    fileprivate var storage = [CompletedTransitionContext]()
    
    public init() {}
    
    // MARK: - TransitionContextsStack
    public func append(_ context: CompletedTransitionContext)
    {
        updateStack()
        storage.append(context)
    }
    
    public var first: RestoredTransitionContext? {
        updateStack()
        let result: RestoredTransitionContext? = self[0]
        return result
    }
        
    public var last: RestoredTransitionContext? {
        updateStack()
        let last = storage.last
        let restored = RestoredTransitionContext(completedTransition: last)
        return restored
    }
    
    public func popLast()
        -> RestoredTransitionContext?
    {
        updateStack()
        let last = storage.popLast()
        let restored = RestoredTransitionContext(completedTransition: last)
        return restored
    }
    
    public subscript(transitionId: TransitionId) -> RestoredTransitionContext? {
        updateStack()
        let index = indexOfCompletedTransition(transitionId: transitionId)
        let restored: RestoredTransitionContext? = self[index]
        return restored
    }
    
    public func popTo(transitionId: TransitionId)
        -> [RestoredTransitionContext]?
    {
        updateStack()
        let index = indexOfCompletedTransition(transitionId: transitionId)
        let result = popTo(index: index)
        return result
    }
    
    public func preceding(transitionId: TransitionId)
        -> RestoredTransitionContext?
    {
        updateStack()
        let index = indexOfCompletedTransitionPreceding(transitionId: transitionId)
        let restored: RestoredTransitionContext? = self[index]
        return restored
    }
}

// MARK: - private
private extension TransitionContextsStackImpl {
    /// Убирает из стека те записи о совершенных переходах, в которых контроллер,
    /// на который осуществлялся переход, уже освобожден
    func updateStack()
    {
        let stack = storage.filter { !$0.isZombie }
        storage = stack
    }
    
    func indexOfCompletedTransition(transitionId: TransitionId)
        -> Int?
    {
        let transitionIds = storage.map { $0.transitionId }
        if let index = transitionIds.index(where: { $0 == transitionId }), index < storage.count {
            return index
        }
        return nil
    }
    
    func indexOfCompletedTransitionPreceding(transitionId: TransitionId)
        -> Int?
    {
        if let index = indexOfCompletedTransition(transitionId: transitionId), index > 0 {
            return index - 1
        }
        return nil
    }
    
    subscript(index: Int?) -> CompletedTransitionContext? {
        if let index = index, index >= 0 && index < storage.count {
            return storage[index]
        }
        return nil
    }
    
    subscript(index: Int?) -> RestoredTransitionContext? {
        let completed: CompletedTransitionContext? = self[index]
        let restored = RestoredTransitionContext(completedTransition: completed)
        return restored
    }
    
    /// Выходит до индекса невключительно. То есть максимально выходит до первой записи
    func popTo(index: Int?)
        -> [RestoredTransitionContext]?
    {
        guard let nonNegative = index, index! >= 0
            else { return nil }
        
        // заранее проверяем, если не попадем в цикл for, чтобы не создавать пустой массив result
        guard let fromIndex = (nonNegative + 1) as Int?, fromIndex < storage.count
            else { return nil }
        
        var result = [RestoredTransitionContext]()
        
        for _ in fromIndex ..< storage.count {
            if let last = popLast() {
                // складываем в том порядке как вынимали
                result.append(last)
            } else { break }
        }
        
        return result
    }
}

// MARK: - CustomDebugStringConvertible
extension TransitionContextsStackImpl: CustomDebugStringConvertible {
    public var debugDescription: String {
        updateStack()
        
        var description = "TransitionContextsStack: " + String(describing: Unmanaged.passUnretained(self).toOpaque())
        description += "\n   --- all ids: \(storage.map( { $0.transitionId }))"
        return description
    }
}
