import Foundation

class BaseRouter {
    private unowned var transitionsHandlerPrivate: TransitionsHandler
    private var transitionIdPrivate: TransitionId
    private weak var presentingTransitionsHandlerPrivate: TransitionsHandler?
    
    init(
        transitionsHandler: TransitionsHandler,
        transitionId: TransitionId,
        presentingTransitionsHandler: TransitionsHandler?)
    {
        transitionIdPrivate = transitionId
        transitionsHandlerPrivate = transitionsHandler
        presentingTransitionsHandlerPrivate = presentingTransitionsHandler
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
    weak var presentingTransitionsHandler: TransitionsHandler? {
        return presentingTransitionsHandlerPrivate
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