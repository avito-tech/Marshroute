// Делегат роутера, нужен для того, чтобы отслеживать переходы еще до того как они случились
public protocol RouterTransitionDelegate: AnyObject {
    func routerWillPerformTransitionWith(transitionId: TransitionId)
}
