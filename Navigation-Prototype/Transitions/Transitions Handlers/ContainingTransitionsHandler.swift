/// Базовый класс для содержащих обработчиков переходов
class ContainingTransitionsHandler: TransitionsHandlerContainer, TransitionsCoordinatorHolder {

// пришлось сделать классом, а не композицией протоколов и не typealias'ом на композицию протоколов,
// из-за странного поведения. 
// `typealias P = protocol<A, B>` не будет подходить под ограничение
// `where T: B` на дженерик тип `T`

    // MARK: - TransitionsCoordinatorHolder    
    let transitionsCoordinator: TransitionsCoordinator
    
    init(transitionsCoordinator: TransitionsCoordinator)
    {
        self.transitionsCoordinator = transitionsCoordinator
    }

    // MARK: - TransitionsHandlerContainer
    var allTransitionsHandlers: [AnimatingTransitionsHandler]? {
        return nil
    }
    
    var visibleTransitionsHandlers: [AnimatingTransitionsHandler]? {
        return nil
    }
}

// MARK: - TransitionsHandler
extension ContainingTransitionsHandler: TransitionsHandler {
    func performTransition(context context: ForwardTransitionContext) {
        transitionsCoordinator.coordinatePerformingTransition(context: context, forContainingTransitionsHandler: self)
    }
    
    func undoTransitionsAfter(transitionId transitionId: TransitionId) {
        transitionsCoordinator.coordinateUndoingTransitionsAfter(transitionId: transitionId, forContainingTransitionsHandler: self)
    }
    
    func undoTransitionWith(transitionId transitionId: TransitionId) {
        transitionsCoordinator.coordinateUndoingTransitionWith(transitionId: transitionId, forContainingTransitionsHandler: self)
    }
    
    func undoAllChainedTransitions() {
        assert(false, "такой метод нельзя посылать контейнеру обработчиков переходов. только анимирующему обработчику")
    }
    
    func undoAllTransitions() {
        assert(false, "такой метод нельзя посылать контейнеру обработчиков переходов. только анимирующему обработчику")
    }
    
    func resetWithTransition(context context: ForwardTransitionContext) {
        assert(false, "такой метод нельзя посылать контейнеру обработчиков переходов. только анимирующему обработчику")
    }
}