import Foundation

/// Обычный роутер, работающий только одним обработчиком переходов
class BaseRouter {
    let transitionsHandlerBox: RouterTransitionsHandlerBox?
    let transitionId: TransitionId
    weak var presentingTransitionsHandler: TransitionsHandler?
    let transitionsCoordinator: TransitionsCoordinator
    let transitionIdGenerator: TransitionIdGenerator
    
    init(
        transitionsHandlerBox: RouterTransitionsHandlerBox,
        transitionId: TransitionId,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionsCoordinator: TransitionsCoordinator,
        transitionIdGenerator: TransitionIdGenerator)
    {
        self.transitionId = transitionId
        self.transitionsHandlerBox = transitionsHandlerBox
        self.presentingTransitionsHandler = presentingTransitionsHandler
        self.transitionsCoordinator = transitionsCoordinator
        self.transitionIdGenerator = transitionIdGenerator
    }
}

// MARK: - RouterIdentifiable
extension BaseRouter: RouterIdentifiable {}

// MARK: - RouterPresentable
extension BaseRouter: RouterPresentable {}

// MARK: - MasterRouterTransitionable
extension BaseRouter: MasterRouterTransitionable {
    var masterTransitionsHandlerBox: RouterTransitionsHandlerBox? {
        return transitionsHandlerBox
    }
}

// MARK: - RouterTransitionable
extension BaseRouter: RouterTransitionable {}

// MARK: - TransitionsCoordinatorHolder
extension BaseRouter: TransitionsCoordinatorHolder {}

// MARK: - TransitionsGeneratorHolder
extension BaseRouter: TransitionIdGeneratorHolder {}

// MARK: - MasterRouter
extension BaseRouter: MasterRouter {}

// MARK: - Router
extension BaseRouter: Router {}

// MARK: - RouterFocusable
extension BaseRouter: RouterFocusable {}

// MARK: - RouterDismisable
extension BaseRouter: RouterDismisable {}