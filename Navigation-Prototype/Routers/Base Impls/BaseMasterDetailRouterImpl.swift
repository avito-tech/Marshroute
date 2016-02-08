import Foundation

/// Роутер для master контроллера внутри SplitViewController'а
/// Работаюет с двумя обработчиками переходов (master и detail)
class BaseMasterDetailRouterImpl {
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
extension BaseMasterDetailRouterImpl: RouterIdentifiable {}

// MARK: - RouterPresentable
extension BaseMasterDetailRouterImpl: RouterPresentable {}

// MARK: - MasterRouterTransitionable
extension BaseMasterDetailRouterImpl: MasterRouterTransitionable {}

// MARK: - DetailRouterTransitionable
extension BaseMasterDetailRouterImpl: DetailRouterTransitionable {
    weak var transitionsHandler: TransitionsHandler? {
        return masterTransitionsHandler
    }
}

// MARK: - RouterTransitionable
extension BaseMasterDetailRouterImpl: RouterTransitionable {}

// MARK: - TransitionsCoordinatorStorer
extension BaseMasterDetailRouterImpl: TransitionsCoordinatorStorer {}

// MARK: - TransitionsGeneratorStorer
extension BaseMasterDetailRouterImpl: TransitionsGeneratorStorer {}

// MARK: - Router
extension BaseMasterDetailRouterImpl: Router {}

// MARK: - MasterRouter
extension BaseMasterDetailRouterImpl: MasterRouter {}

// MARK: - DetailRouter
extension BaseMasterDetailRouterImpl: DetailRouter {}

// MARK: - RouterFocusable
extension BaseMasterDetailRouterImpl: RouterFocusable {}

// MARK: - RouterDismisable
extension BaseMasterDetailRouterImpl: RouterDismisable  {}