import Foundation

protocol RouterTransitionable: class {
    /// сильная ссылка на обработчика переходов
    var transitionsHandler: TransitionsHandler { get }
}