import Foundation

protocol RouterTransitionable: class {
    /// слабая ссылка на обработчика переходов из роутера
    unowned var transitionsHandler: TransitionsHandler { get }
}