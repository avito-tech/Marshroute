/// Протокол, описывающий обработчики переходов для модулей-контейнеров, у которых более одной ветви навигации (таббар, сплитвью).
/// см также AnimatingTransitionsHandler
public protocol ContainingTransitionsHandler: TransitionsHandlerContainer, TransitionsHandler {}

/// Базовый класс для содержащих обработчиков переходов
open class BaseContainingTransitionsHandler: ContainingTransitionsHandler, TransitionsCoordinatorHolder {
    // MARK: - TransitionsCoordinatorHolder    
    public let transitionsCoordinator: TransitionsCoordinator
    
    public init(transitionsCoordinator: TransitionsCoordinator)
    {
        self.transitionsCoordinator = transitionsCoordinator
    }

    // MARK: - TransitionsHandlerContainer
    open var allTransitionsHandlers: [AnimatingTransitionsHandler]? {
        return nil
    }
    
    open var visibleTransitionsHandlers: [AnimatingTransitionsHandler]? {
        return nil
    }

    // MARK: - TransitionsHandler
    open func performTransition(context: PresentationTransitionContext)
    {
        transitionsCoordinator.coordinatePerformingTransition(context: context, forContainingTransitionsHandler: self)
    }
    
    open func undoTransitionsAfter(transitionId: TransitionId)
    {
        transitionsCoordinator.coordinateUndoingTransitionsAfter(transitionId: transitionId, forContainingTransitionsHandler: self)
    }
    
    open func undoTransitionWith(transitionId: TransitionId)
    {
        transitionsCoordinator.coordinateUndoingTransitionWith(transitionId: transitionId, forContainingTransitionsHandler: self)
    }
    
    open func undoAllChainedTransitions()
    {
        marshrouteAssertionFailure("Метод \(#function) нельзя посылать контейнеру обработчиков переходов. Только анимирующему обработчику")
    }
    
    open func undoAllTransitions()
    {
        marshrouteAssertionFailure("Метод \(#function) нельзя посылать контейнеру обработчиков переходов. Только анимирующему обработчику")
    }
    
    open func resetWithTransition(context: ResettingTransitionContext)
    {
        marshrouteAssertionFailure("Метод \(#function) нельзя посылать контейнеру обработчиков переходов. Только анимирующему обработчику")
    }
}
