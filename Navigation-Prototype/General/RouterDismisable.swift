/**
 *  Методы, чтобы вернуться на экран модуля, показавшего экран текущего модуля
 */
protocol RouterDismisable: class {
    /// ссылка на обработчика переходов, которого попросили показать модуль текущего роутера. 
    /// с помощью этой ссылки роутер может попросить обработчика переходов
    /// убрать свой модуль и вернуться на предыдущий модуль через
    /// ```swift
    /// undoTransitionWith(transitionId:)
    weak var parentTransitionsHandler: TransitionsHandler? { get }
    
    /// идентификатор перехода
    var transitionId: TransitionId { get }
}

extension RouterDismisable {
    func returnToPresentingModule() {
        parentTransitionsHandler?.undoTransitionWith(transitionId: transitionId)
    }
}