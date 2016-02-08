import Foundation

/// Обычный роутер, работающий только одним обработчиком переходов
class BaseRouterImpl {
    weak var transitionsHandler: TransitionsHandler?
    let transitionId: TransitionId
    weak var presentingTransitionsHandler: TransitionsHandler?
    let transitionsCoordinator: TransitionsCoordinator
    let transitionIdGenerator: TransitionIdGenerator
    
    init(
        transitionsHandler: TransitionsHandler,
        transitionId: TransitionId,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionsCoordinator: TransitionsCoordinator,
        transitionIdGenerator: TransitionIdGenerator)
    {
        self.transitionId = transitionId
        self.transitionsHandler = transitionsHandler
        self.presentingTransitionsHandler = presentingTransitionsHandler
        self.transitionsCoordinator = transitionsCoordinator
        self.transitionIdGenerator = transitionIdGenerator
    }
}

// MARK: - RouterIdentifiable
extension BaseRouterImpl: RouterIdentifiable {}

// MARK: - RouterPresentable
extension BaseRouterImpl: RouterPresentable {}

// MARK: - MasterRouterTransitionable
extension BaseRouterImpl: MasterRouterTransitionable {
    var masterTransitionsHandler: TransitionsHandler? {
        return transitionsHandler
    }
}

// MARK: - RouterTransitionable
extension BaseRouterImpl: RouterTransitionable {}

// MARK: - TransitionsCoordinatorStorer
extension BaseRouterImpl: TransitionsCoordinatorStorer {}

// MARK: - TransitionsGeneratorStorer
extension BaseRouterImpl: TransitionsGeneratorStorer {}

// MARK: - MasterRouter
extension BaseRouterImpl: MasterRouter {}

// MARK: - Router
extension BaseRouterImpl: Router {}

// MARK: - RouterFocusable
extension BaseRouterImpl: RouterFocusable {}

// MARK: - RouterDismisable
extension BaseRouterImpl: RouterDismisable {}