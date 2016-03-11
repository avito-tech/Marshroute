/// Хранение соответствия между обработчиком переходов и обслуживающим его клиентом стэка переходов
struct TransitionsHistoryItem {
    let stackClient: TransitionContextsStackClient
    private(set) weak var transitionsHandler: TransitionsHandler?
    
    init (stackClient: TransitionContextsStackClient,
        transitionsHandler: TransitionsHandler)
    {
        self.stackClient = stackClient
        self.transitionsHandler = transitionsHandler
    }
}