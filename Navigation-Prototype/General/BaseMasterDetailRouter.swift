import Foundation

class BaseMasterDetailRouter {
    private var masterTransitionsHandlerPrivate: TransitionsHandler
    private var detailTransitionsHandlerPrivate: TransitionsHandler
    private var transitionIdPrivate: TransitionId
    private var presentedTransitionsHandlerPrivate: TransitionsHandler?
    
    init(
        masterTransitionsHandler: TransitionsHandler,
        detailTransitionsHandler: TransitionsHandler,
        transitionId: TransitionId,
        presentedTransitionsHandler: TransitionsHandler?)
    {
        transitionIdPrivate = transitionId
        masterTransitionsHandlerPrivate = masterTransitionsHandler
        detailTransitionsHandlerPrivate = detailTransitionsHandler
        presentedTransitionsHandlerPrivate = presentedTransitionsHandler
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
    var presentedTransitionsHandler: TransitionsHandler? {
        return presentedTransitionsHandlerPrivate
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
