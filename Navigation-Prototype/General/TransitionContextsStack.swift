/// Стэк, который хранит CompletedTransitionContext, а возвращает RestoredTransitionContext
class TransitionContextsStack {
    private var transitionsStack = [CompletedTransitionContext]()
    
    func append(context: CompletedTransitionContext) {
        updateTransitionsStack()
        transitionsStack.append(context)
    }
    
    var last: RestoredTransitionContext? {
        get {
            updateTransitionsStack()
            let last = transitionsStack.last
            let restored = RestoredTransitionContext(context: last)
            return restored
        }
    }
    
    func popLast()
        -> RestoredTransitionContext?
    {
        updateTransitionsStack()
        let poppedLast = transitionsStack.popLast()
        let restored = RestoredTransitionContext(context: poppedLast)
        return restored
    }
    
    /// восстановленное описание последнего перехода с тем отличием, 
    /// что sourceViewController и sourceTransitionHandler у него взяты
    /// из описания самого первого перехода
    var lastToFirst: RestoredTransitionContext? {
        get {
            updateTransitionsStack()
            
            let last = transitionsStack.last
            let first = transitionsStack.first
            
            let restored = (last == first)
            ? RestoredTransitionContext(context: last)
            : RestoredTransitionContext(fromSourceContext: first, toTargetContext: last)
            
            return restored
        }
    }
    
    func removeAll() {
        transitionsStack.removeAll()
    }
 
    func lastToContext(context: BackwardTransitionContext)
        -> RestoredTransitionContext?
    {
        updateTransitionsStack()
        
        guard let to = completedTransitionContext(forBackwardContext: context)
            else { return nil }
        
        let last = transitionsStack.last
        
        let restored = (last == to)
            ? RestoredTransitionContext(context: last)
            : RestoredTransitionContext(fromSourceContext: to, toTargetContext: last)

        return restored
    }
    
    func popToContext(context: BackwardTransitionContext)
        -> RestoredTransitionContext?
    {
        updateTransitionsStack()
        
        guard let index = indexOfCompletedTransition(forBackwardContext: context)
            else { return nil }
        
        guard index < transitionsStack.count
            else { return nil }
        
        var last: CompletedTransitionContext? = nil
        
        for _ in index ..< transitionsStack.count {
            last = transitionsStack.popLast()
        }
        
        let restored = RestoredTransitionContext(context: last)
        return restored
    }
    
    
    func canBePoppedToContext(context: BackwardTransitionContext)
        -> Bool
    {
        updateTransitionsStack()
        let index = indexOfCompletedTransition(forBackwardContext: context)
        return index != nil
    }
    
    private func indexOfCompletedTransition(forBackwardContext context: BackwardTransitionContext)
        -> Int?
    {
        let sourceViewControllers = transitionsStack.map() { $0.sourceViewController }
        let index = sourceViewControllers.indexOf({ $0 === context.targetViewController })
        return index
    }

    private func completedTransitionContext(forBackwardContext context: BackwardTransitionContext)
        -> CompletedTransitionContext?
    {
        if let index = indexOfCompletedTransition(forBackwardContext: context) {
            return transitionsStack[index]
        }
        return nil
    }
    
    func canBePoppedToTransition(id transitionId: TransitionId)
        -> Bool
    {
        updateTransitionsStack()
        let index = indexOfCompletedTransition(forTransitionId: transitionId)
        return index != nil
    }
    
    private func indexOfCompletedTransition(forTransitionId transitionId: TransitionId)
        -> Int?
    {
        let transitionIds = transitionsStack.map() { $0.transitionId }
        let index = transitionIds.indexOf({ $0 == transitionId })
        return index
    }
    
    private func completedTransitionContextForTransition(id transitionId: TransitionId)
        -> CompletedTransitionContext?
    {
        if let index = indexOfCompletedTransition(forTransitionId: transitionId) {
            return transitionsStack[index]
        }
        return nil
    }
}

// MARK: - private
private extension TransitionContextsStack {
    /**
     Убирает из стека те записи о совершенных переходах, в которых контроллер, 
     на который осуществлялся переход, уже освобожден
     */
    func updateTransitionsStack() {
        let transitionsStack = self.transitionsStack.filter({ !$0.isZombie })
        self.transitionsStack = transitionsStack
    }
}

// MARK: - convenience RestoredTransitionContext initializer
private extension RestoredTransitionContext {
    init?(
        fromSourceContext sourceContext: CompletedTransitionContext?,
        toTargetContext targetContext: CompletedTransitionContext?)
    {
        guard let sourceContext = sourceContext
            else { return nil }
        guard let sourceViewController = sourceContext.sourceViewController
            else { return nil }
        guard let sourceTransitionsHandler = sourceContext.sourceTransitionsHandler
            else { return nil }
        
        guard let targetContext = targetContext
            else { return nil }
        guard let targetViewController = targetContext.targetViewController
            else { return nil }
        guard let targetTransitionsHandler = targetContext.targetTransitionsHandler
            else { return nil }
        
        self.sourceViewController = sourceViewController
        self.sourceTransitionsHandler = sourceTransitionsHandler
        
        self.targetViewController = targetViewController
        self.targetTransitionsHandler = targetTransitionsHandler
        self.transitionStyle = targetContext.transitionStyle
        self.storableParameters = targetContext.storableParameters
        self.animator = targetContext.animator
        
        // неважно, какой тут transitionId. можно и targetContext.transitionId
        self.transitionId = sourceContext.transitionId
    }
}

// MARK: - CompletedTransitionContext: Equatable
extension CompletedTransitionContext: Equatable {}

func ==(lhs: CompletedTransitionContext, rhs: CompletedTransitionContext) -> Bool {
    let result = lhs.targetViewController == rhs.targetViewController
    return result
}