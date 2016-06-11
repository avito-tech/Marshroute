import Marshroute

struct ApplicationModuleSeed {
    let transitionId: TransitionId
    let presentingTransitionsHandler: TransitionsHandler?
    let marshrouteNavigationStack: MarshrouteNavigationStack
}

extension RouterSeed {
    init(
        moduleSeed: ApplicationModuleSeed,
        transitionsHandlerBox: TransitionsHandlerBox)
    {
        self.transitionsHandlerBox = transitionsHandlerBox
        self.transitionId = moduleSeed.transitionId
        self.presentingTransitionsHandler = moduleSeed.presentingTransitionsHandler
        self.transitionsHandlersProvider = moduleSeed.marshrouteNavigationStack.transitionsHandlersProvider
        self.transitionIdGenerator = moduleSeed.marshrouteNavigationStack.transitionIdGenerator
        self.controllersProvider = moduleSeed.marshrouteNavigationStack.routerControllersProvider
    }
}

extension MasterDetailRouterSeed {
    init(
        moduleSeed: ApplicationModuleSeed,
        masterTransitionsHandlerBox: TransitionsHandlerBox,
        detailTransitionsHandlerBox: TransitionsHandlerBox)
    {
        self.masterTransitionsHandlerBox = masterTransitionsHandlerBox
        self.detailTransitionsHandlerBox = detailTransitionsHandlerBox
        self.transitionId = moduleSeed.transitionId
        self.presentingTransitionsHandler = moduleSeed.presentingTransitionsHandler
        self.transitionsHandlersProvider = moduleSeed.marshrouteNavigationStack.transitionsHandlersProvider
        self.transitionIdGenerator = moduleSeed.marshrouteNavigationStack.transitionIdGenerator
        self.controllersProvider = moduleSeed.marshrouteNavigationStack.routerControllersProvider
    }
}