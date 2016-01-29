import Foundation

/**
 *  для хранения сильной ссылки на обработчика переходов. (ссылку должны хранить роутеры)
 */
protocol RouterPresentable: class {
    /// слабая на обработчика переходов, показавшего модуль текущего роутера.
    /// с помощью этой ссылки роутер может попросить обработчика переходов
    /// убрать свой модуль и вернуться на предыдущий модуль через
    /// ```swift
    /// undoTransitionWith(transitionId:)
    weak var presentingTransitionsHandler: TransitionsHandler? { get }
}