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
    
    func popLast() -> RestoredTransitionContext? {
        updateTransitionsStack()
        let poppedLast = transitionsStack.popLast()
        let restored = RestoredTransitionContext(context: poppedLast)
        return restored
    }
    
    /// восстановленное описание последнего перехода с тем отличием, 
    /// что sourceViewController у него взят из описания самого первого перехода
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
    
    func canBePoppedToContext(context: BackwardTransitionContext) -> Bool {
        updateTransitionsStack()
        let sourceViewControllers = transitionsStack.map() { $0.sourceViewController }
        let result = sourceViewControllers.contains() { $0 === context.targetViewController }
        return result
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
        guard let targetContext = targetContext
            else { return nil }
        guard let targetViewController = targetContext.targetViewController
            else { return nil }
        // TODO: aaa вернуть проверку
        //guard let transitionsHandler = targetContext.targetTransitionsHandler
        //else { return nil }
        
        guard let sourceViewController = sourceContext?.sourceViewController
            else { return nil }

        self.targetViewController = targetViewController
        self.sourceViewController = sourceViewController
        // TODO: aaa вернуть утверждение (и проверку сверху)
        // self.transitionsHandler = transitionsHandler
        self.transitionsHandler = targetContext.targetTransitionsHandler
        self.transitionStyle = targetContext.transitionStyle
        self.storableParameters = targetContext.storableParameters
        self.animator = targetContext.animator
    }
}

// MARK: - CompletedTransitionContext: Equatable
extension CompletedTransitionContext: Equatable {}

func ==(lhs: CompletedTransitionContext, rhs: CompletedTransitionContext) -> Bool {
    let result = lhs.targetViewController == rhs.targetViewController
    return result
}