import Foundation

class BaseRouter {
    private var transitionsHandlerPrivate: TransitionsHandler
    private var transitionIdPrivate: TransitionId
    private var presentedTransitionsHandlerPrivate: TransitionsHandler?
    
    init(
        transitionsHandler: TransitionsHandler,
        transitionId: TransitionId,
        presentedTransitionsHandler: TransitionsHandler?)
    {
        transitionIdPrivate = transitionId
        transitionsHandlerPrivate = transitionsHandler
        presentedTransitionsHandlerPrivate = presentedTransitionsHandler
    }
}

// MARK: - RouterIdentifiable
extension BaseRouter: RouterIdentifiable {
    var transitionId: TransitionId {
        return transitionIdPrivate
    }
}

// MARK: - RouterPresentable
extension BaseRouter: RouterPresentable {
    var presentedTransitionsHandler: TransitionsHandler? {
        return presentedTransitionsHandlerPrivate
    }
}

// MARK: - MasterRouterTransitionable
extension BaseRouter: MasterRouterTransitionable {
    var masterTransitionsHandler: TransitionsHandler {
        return transitionsHandlerPrivate
    }
}

// MARK: - RouterTransitionable
extension BaseRouter: RouterTransitionable {
    var transitionsHandler: TransitionsHandler {
        return transitionsHandlerPrivate
    }
}

// MARK: - TransitionsGeneratorStorer
extension BaseRouter: TransitionsGeneratorStorer {}

// MARK: - MasterRouter
extension BaseRouter: MasterRouter {}

// MARK: - Router
extension BaseRouter: Router {}

// MARK: - RouterFocusable
extension BaseRouter: RouterFocusable {}

// MARK: - RouterDismisable
extension BaseRouter: RouterDismisable  {}