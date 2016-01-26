/**
 *  Методы, чтобы вернуться на экран модуля, показавшего экран текущего модуля
 */
protocol RouterDismisable: class {
    /// ссылка на обработчика переходов, которого попросили показать модуль текущего роутера. 
    /// с помощью этой ссылки роутер может попросить обработчика переходов
    /// убрать свой модуль и вернуться на предыдущий модуль через
    /// ```swift
    /// undoTransition(id:)
    weak var presentingTransitionsHandler: TransitionsHandler? { get set }
    
    /// идентификатор перехода
    var transitionId: TransitionId? { get set }
}

extension RouterDismisable {
    func returnToPresentingModule() {
        if let transitionId = transitionId {
            presentingTransitionsHandler?.undoTransition(id: transitionId)
        }
    }
}