import Foundation

protocol MasterRouterTransitionable: class {
    /// сильная ссылка на обработчика переходов
    var masterTransitionsHandler: TransitionsHandler { get }
}