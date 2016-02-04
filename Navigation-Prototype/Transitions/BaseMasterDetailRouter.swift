import Foundation

class BaseMasterDetailRouterImpl {
    private unowned let masterTransitionsHandlerPrivate: TransitionsHandler
    private unowned let detailTransitionsHandlerPrivate: TransitionsHandler
    private let transitionIdPrivate: TransitionId
    private weak var presentingTransitionsHandlerPrivate: TransitionsHandler?
    private let transitionsCoordinatorPrivate: TransitionsCoordinator
    
    init(
        masterTransitionsHandler: TransitionsHandler,
        detailTransitionsHandler: TransitionsHandler,
        transitionId: TransitionId,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionsCoordinator: TransitionsCoordinator)
    {
        self.transitionIdPrivate = transitionId
        self.masterTransitionsHandlerPrivate = masterTransitionsHandler
        self.detailTransitionsHandlerPrivate = detailTransitionsHandler
        self.presentingTransitionsHandlerPrivate = presentingTransitionsHandler
        self.transitionsCoordinatorPrivate = transitionsCoordinator
    }
}

// MARK: - RouterIdentifiable
extension BaseMasterDetailRouterImpl: RouterIdentifiable {
    var transitionId: TransitionId {
        return transitionIdPrivate
    }
}

// MARK: - RouterPresentable
extension BaseMasterDetailRouterImpl: RouterPresentable {
    weak var presentingTransitionsHandler: TransitionsHandler? {
        return presentingTransitionsHandlerPrivate
    }
}

// MARK: - MasterRouterTransitionable
extension BaseMasterDetailRouterImpl: MasterRouterTransitionable {
    var masterTransitionsHandler: TransitionsHandler {
        return masterTransitionsHandlerPrivate
    }
}

// MARK: - DetailRouterTransitionable
extension BaseMasterDetailRouterImpl: DetailRouterTransitionable {
    var detailTransitionsHandler: TransitionsHandler {
        return detailTransitionsHandlerPrivate
    }
}

// MARK: - RouterTransitionable
extension BaseMasterDetailRouterImpl: RouterTransitionable {
    var transitionsHandler: TransitionsHandler {
        return masterTransitionsHandlerPrivate
    }
}

// MARK: - TransitionsCoordinatorStorer
extension BaseMasterDetailRouterImpl: TransitionsCoordinatorStorer {
    var transitionsCoordinator: TransitionsCoordinator {
        return transitionsCoordinatorPrivate
    }
}

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