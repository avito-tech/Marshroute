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
        self.transitionsHandlerBox = transitionsHandlerBox
        self.transitionId = moduleSeed.transitionId
        self.presentingTransitionsHandler = moduleSeed.presentingTransitionsHandler
        self.transitionsHandlersProvider = moduleSeed.marshrouteStack.transitionsHandlersProvider
        self.transitionIdGenerator = moduleSeed.marshrouteStack.transitionIdGenerator
        self.controllersProvider = moduleSeed.marshrouteStack.routerControllersProvider
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
        self.transitionsHandlersProvider = moduleSeed.marshrouteStack.transitionsHandlersProvider
        self.transitionIdGenerator = moduleSeed.marshrouteStack.transitionIdGenerator
        self.controllersProvider = moduleSeed.marshrouteStack.routerControllersProvider
    }
}