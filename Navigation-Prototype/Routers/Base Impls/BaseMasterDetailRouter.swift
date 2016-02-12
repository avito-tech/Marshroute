import Foundation

/// Роутер для master контроллера внутри SplitViewController'а
/// Работаюет с двумя обработчиками переходов (master и detail)
class BaseMasterDetailRouter {
    let masterTransitionsHandlerBox: RouterTransitionsHandlerBox?
    let detailTransitionsHandlerBox: RouterTransitionsHandlerBox?
    let transitionId: TransitionId
    weak var presentingTransitionsHandler: TransitionsHandler?
    let transitionsCoordinator: TransitionsCoordinator
    let transitionIdGenerator: TransitionIdGenerator
    
    init(
        masterTransitionsHandlerBox: RouterTransitionsHandlerBox,
        detailTransitionsHandlerBox: RouterTransitionsHandlerBox,
        transitionId: TransitionId,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionsCoordinator: TransitionsCoordinator,
        transitionIdGenerator: TransitionIdGenerator)
    {
        self.transitionId = transitionId
        self.masterTransitionsHandlerBox = masterTransitionsHandlerBox
        self.detailTransitionsHandlerBox = detailTransitionsHandlerBox
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
extension BaseMasterDetailRouter: DetailRouterTransitionable {}

// MARK: - RouterTransitionable
extension BaseMasterDetailRouter: RouterTransitionable {
    var transitionsHandlerBox: RouterTransitionsHandlerBox? {
        return masterTransitionsHandlerBox
    }
}

// MARK: - TransitionsCoordinatorHolder
extension BaseMasterDetailRouter: TransitionsCoordinatorHolder {}

// MARK: - TransitionsGeneratorHolder
extension BaseMasterDetailRouter: TransitionIdGeneratorHolder {}

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