/// Стэк, который хранит CompletedTransitionContext, а возвращает RestoredTransitionContext.
/// Стэк хранит историю переходов по одному навигационному контроллеру.
/// Стэк может завершаться переходом на дочернего обработчика переходов (на модальное окно или поповер)
protocol TransitionContextsStack: class {
    func append(context: CompletedTransitionContext)

    var first: RestoredTransitionContext? { get }
    
    var last: RestoredTransitionContext? { get }
    
    func popLast()
        -> RestoredTransitionContext?
    
    subscript (transitionId: TransitionId)
        -> RestoredTransitionContext? { get }
    
    func popTo(transitionId transitionId: TransitionId)
        -> [RestoredTransitionContext]?
    
    func preceding(transitionId transitionId: TransitionId)
        -> RestoredTransitionContext?
}