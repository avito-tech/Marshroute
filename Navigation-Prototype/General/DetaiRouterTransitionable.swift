import Foundation

protocol DetailRouterTransitionable: class {
    /// слабая ссылка на обработчика переходов
    unowned var detailTransitionsHandler: TransitionsHandler { get }
}