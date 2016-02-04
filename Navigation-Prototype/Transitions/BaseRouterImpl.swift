import Foundation

class BaseRouterImpl {
    private unowned let transitionsHandlerPrivate: TransitionsHandler
    private let transitionIdPrivate: TransitionId
    private weak var presentingTransitionsHandlerPrivate: TransitionsHandler?
    private let transitionsCoordinatorPrivate: TransitionsCoordinator
    
    init(
        transitionsHandler: TransitionsHandler,
        transitionId: TransitionId,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionsCoordinator: TransitionsCoordinator)
    {
        self.transitionIdPrivate = transitionId
        self.transitionsHandlerPrivate = transitionsHandler
        self.presentingTransitionsHandlerPrivate = presentingTransitionsHandler
        self.transitionsCoordinatorPrivate = transitionsCoordinator
    }
}

// MARK: - RouterIdentifiable
extension BaseRouterImpl: RouterIdentifiable {
    var transitionId: TransitionId {
        return transitionIdPrivate
    }
}

// MARK: - RouterPresentable
extension BaseRouterImpl: RouterPresentable {
    weak var presentingTransitionsHandler: TransitionsHandler? {
        return presentingTransitionsHandlerPrivate
    }
}

// MARK: - MasterRouterTransitionable
extension BaseRouterImpl: MasterRouterTransitionable {
    var masterTransitionsHandler: TransitionsHandler {
        return transitionsHandlerPrivate
    }
}

// MARK: - RouterTransitionable
extension BaseRouterImpl: RouterTransitionable {
    var transitionsHandler: TransitionsHandler {
        return transitionsHandlerPrivate
    }
}

// MARK: - TransitionsCoordinatorStorer
extension BaseRouterImpl: TransitionsCoordinatorStorer {
    var transitionsCoordinator: TransitionsCoordinator {
        return transitionsCoordinatorPrivate
    }
}

// MARK: - TransitionsGeneratorStorer
extension BaseRouterImpl: TransitionsGeneratorStorer {}

// MARK: - MasterRouter
extension BaseRouterImpl: MasterRouter {}

// MARK: - Router
extension BaseRouterImpl: Router {}

// MARK: - RouterFocusable
extension BaseRouterImpl: RouterFocusable {}

// MARK: - RouterDismisable
extension BaseRouterImpl: RouterDismisable  {}