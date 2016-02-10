import Foundation

/// Роутер для master контроллера внутри SplitViewController'а
/// Работаюет с двумя обработчиками переходов (master и detail)
class BaseMasterDetailRouter {
    weak var masterTransitionsHandler: TransitionsHandler?
    weak var detailTransitionsHandler: TransitionsHandler?
    let transitionId: TransitionId
    weak var presentingTransitionsHandler: TransitionsHandler?
    let transitionsCoordinator: TransitionsCoordinator
    let transitionIdGenerator: TransitionIdGenerator
    
    init(
        masterTransitionsHandler: TransitionsHandler,
        detailTransitionsHandler: TransitionsHandler,
        transitionId: TransitionId,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionsCoordinator: TransitionsCoordinator,
        transitionIdGenerator: TransitionIdGenerator)
    {
        self.transitionId = transitionId
        self.masterTransitionsHandler = masterTransitionsHandler
        self.detailTransitionsHandler = detailTransitionsHandler
        self.presentingTransitionsHandler = presentingTransitionsHandler
        self.transitionsCoordinator = transitionsCoordinator
        self.transitionIdGenerator = transitionIdGenerator
    }
}

// MARK: - RouterIdentifiable
extension BaseMasterDetailRouter: RouterIdentifiable {}

// MARK: - RouterPresentable
extension BaseMasterDetailRouter: RouterPresentable {}

// MARK: - MasterRouterTransitionable
extension BaseMasterDetailRouter: MasterRouterTransitionable {}

// MARK: - DetailRouterTransitionable
extension BaseMasterDetailRouter: DetailRouterTransitionable {
    weak var transitionsHandler: TransitionsHandler? {
        return masterTransitionsHandler
    }
}

// MARK: - RouterTransitionable
extension BaseMasterDetailRouter: RouterTransitionable {}

// MARK: - TransitionsCoordinatorStorer
extension BaseMasterDetailRouter: TransitionsCoordinatorStorer {}

// MARK: - TransitionsGeneratorStorer
extension BaseMasterDetailRouter: TransitionsGeneratorStorer {}

// MARK: - Router
extension BaseMasterDetailRouter: Router {}

// MARK: - MasterRouter
extension BaseMasterDetailRouter: MasterRouter {}

// MARK: - DetailRouter
extension BaseMasterDetailRouter: DetailRouter {}

// MARK: - RouterFocusable
extension BaseMasterDetailRouter: RouterFocusable {}

// MARK: - RouterDismisable
extension BaseMasterDetailRouter: RouterDismisable  {}