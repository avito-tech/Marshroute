import Foundation

class BaseMasterDetailRouter {
    private var masterTransitionsHandlerPrivate: TransitionsHandler
    private var detailTransitionsHandlerPrivate: TransitionsHandler
    private var transitionIdPrivate: TransitionId
    private var presentingTransitionsHandlerPrivate: TransitionsHandler?
    
    init(
        masterTransitionsHandler: TransitionsHandler,
        detailTransitionsHandler: TransitionsHandler,
        transitionId: TransitionId,
        presentingTransitionsHandler: TransitionsHandler?)
    {
        transitionIdPrivate = transitionId
        masterTransitionsHandlerPrivate = masterTransitionsHandler
        detailTransitionsHandlerPrivate = detailTransitionsHandler
        presentingTransitionsHandlerPrivate = presentingTransitionsHandler
    }
}

// MARK: - RouterIdentifiable
extension BaseMasterDetailRouter: RouterIdentifiable {
    var transitionId: TransitionId {
        return transitionIdPrivate
    }
}

// MARK: - RouterPresentable
extension BaseMasterDetailRouter: RouterPresentable {
    var presentingTransitionsHandler: TransitionsHandler? {
        return presentingTransitionsHandlerPrivate
    }
}

// MARK: - MasterRouterTransitionable
extension BaseMasterDetailRouter: MasterRouterTransitionable {
    var masterTransitionsHandler: TransitionsHandler {
        return masterTransitionsHandlerPrivate
    }
}

// MARK: - DetailRouterTransitionable
extension BaseMasterDetailRouter: DetailRouterTransitionable {
    var detailTransitionsHandler: TransitionsHandler {
        return detailTransitionsHandlerPrivate
    }
}

// MARK: - RouterTransitionable
extension BaseMasterDetailRouter: RouterTransitionable {
    var transitionsHandler: TransitionsHandler {
        return masterTransitionsHandlerPrivate
    }
}

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