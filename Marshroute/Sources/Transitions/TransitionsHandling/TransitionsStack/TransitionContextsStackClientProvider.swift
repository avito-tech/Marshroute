/// Создание и хранение клиентов, выполняющих обращения к стэку переходов.
/// Поиск клиента, обслуживающего обработчика переходов
public protocol TransitionContextsStackClientProvider: AnyObject {
    func stackClient(forTransitionsHandler transitionsHandler: TransitionsHandler)
        -> TransitionContextsStackClient?

    func createStackClient(forTransitionsHandler transitionsHandler: TransitionsHandler)
        -> TransitionContextsStackClient
}
