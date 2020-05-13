import Marshroute

struct ApplicationModuleSeed {
    let transitionId: TransitionId
    let presentingTransitionsHandler: TransitionsHandler?
    let marshrouteStack: MarshrouteStack
}

extension RouterSeed {
    init(
        moduleSeed: ApplicationModuleSeed,
        transitionsHandlerBox: TransitionsHandlerBox)
    {
        self.init(
            transitionsHandlerBox: transitionsHandlerBox,
            transitionId: moduleSeed.transitionId,
            presentingTransitionsHandler: moduleSeed.presentingTransitionsHandler,
            transitionsHandlersProvider: moduleSeed.marshrouteStack.transitionsHandlersProvider,
            transitionIdGenerator: moduleSeed.marshrouteStack.transitionIdGenerator,
            controllersProvider: moduleSeed.marshrouteStack.routerControllersProvider,
            routerTransitionDelegate: nil
        )
    }
}

extension MasterDetailRouterSeed {
    init(
        moduleSeed: ApplicationModuleSeed,
        masterTransitionsHandlerBox: TransitionsHandlerBox,
        detailTransitionsHandlerBox: TransitionsHandlerBox)
    {
        self.init(
            masterTransitionsHandlerBox: masterTransitionsHandlerBox,
            detailTransitionsHandlerBox: detailTransitionsHandlerBox,
            transitionId: moduleSeed.transitionId,
            presentingTransitionsHandler: moduleSeed.presentingTransitionsHandler,
            transitionsHandlersProvider: moduleSeed.marshrouteStack.transitionsHandlersProvider,
            transitionIdGenerator: moduleSeed.marshrouteStack.transitionIdGenerator,
            controllersProvider: moduleSeed.marshrouteStack.routerControllersProvider,
            routerTransitionDelegate: nil
        )
    }
}
