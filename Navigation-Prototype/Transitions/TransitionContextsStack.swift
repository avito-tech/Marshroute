import Foundation

/**
 *  Стэк, который хранит CompletedTransitionContext, а возвращает RestoredTransitionContext
 */
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