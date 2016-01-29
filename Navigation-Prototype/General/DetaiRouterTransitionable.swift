import Foundation

protocol DetailRouterTransitionable: class {
    /// сильная ссылка на обработчика переходов
    var detailTransitionsHandler: TransitionsHandler { get }
}