/// Хранение слабой ссылки на показавшего текущий модуль обработчика переходов
public protocol RouterPresentable: class {
    /// слабая ссылка на обработчика переходов, показавшего модуль текущего роутера.
    /// с помощью этой ссылки роутер может попросить обработчика переходов
    /// убрать свой модуль и вернуться на предыдущий модуль через
    /// ```swift
    /// undoTransitionWith(transitionId:)
    weak var presentingTransitionsHandler: TransitionsHandler? { get }
}
