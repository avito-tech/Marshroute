import Marshroute

struct ApplicationModuleSeed {
    let transitionId: TransitionId
    let presentingTransitionsHandler: TransitionsHandler?
    let avitoNavigationStack: AvitoNavigationStack
}

extension RouterSeed {
    init(
        moduleSeed: ApplicationModuleSeed,
        transitionsHandlerBox: TransitionsHandlerBox)
    {
        self.transitionsHandlerBox = transitionsHandlerBox
        self.transitionId = moduleSeed.transitionId
        self.presentingTransitionsHandler = moduleSeed.presentingTransitionsHandler
        self.transitionsHandlersProvider = moduleSeed.avitoNavigationStack.transitionsHandlersProvider
        self.transitionIdGenerator = moduleSeed.avitoNavigationStack.transitionIdGenerator
        self.controllersProvider = moduleSeed.avitoNavigationStack.routerControllersProvider
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
        self.transitionsHandlersProvider = moduleSeed.avitoNavigationStack.transitionsHandlersProvider
        self.transitionIdGenerator = moduleSeed.avitoNavigationStack.transitionIdGenerator
        self.controllersProvider = moduleSeed.avitoNavigationStack.routerControllersProvider
    }
}