import Foundation

/// Обычный роутер, работающий только одним обработчиком переходов
class BaseRouter {
    let transitionsHandlerBox: RouterTransitionsHandlerBox?
    let transitionId: TransitionId
    weak var presentingTransitionsHandler: TransitionsHandler?
    let transitionsCoordinator: TransitionsCoordinator
    let transitionIdGenerator: TransitionIdGenerator
    
    init(routerSeed seed: BaseRouterSeed)
    {
        self.transitionId = seed.transitionId
        self.transitionsHandlerBox = seed.transitionsHandlerBox
        self.presentingTransitionsHandler = seed.presentingTransitionsHandler
        self.transitionsCoordinator = seed.transitionsCoordinator
        self.transitionIdGenerator = seed.transitionIdGenerator
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