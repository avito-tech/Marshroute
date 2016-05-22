import AvitoNavigation

struct ApplicationModuleSeed {
    let transitionId: TransitionId
    let presentingTransitionsHandler: TransitionsHandler?
    let transitionsCoordinator: TransitionsCoordinator
    let transitionsCoordinatorDelegateHolder: TransitionsCoordinatorDelegateHolder
    let transitionIdGenerator: TransitionIdGenerator
    let controllersProvider: RouterControllersProvider
    let topViewControllerFinder: TopViewControllerFinder
    let transitionsMarker: TransitionsMarker
    let transitionsTracker: TransitionsTracker
}

extension RouterSeed {
    init(
        moduleSeed: ApplicationModuleSeed,
        transitionsHandlerBox: TransitionsHandlerBox)
    {
        self.transitionsHandlerBox = transitionsHandlerBox
        self.transitionId = moduleSeed.transitionId
        self.presentingTransitionsHandler = moduleSeed.presentingTransitionsHandler
        self.transitionsCoordinator = moduleSeed.transitionsCoordinator
        self.transitionIdGenerator = moduleSeed.transitionIdGenerator
        self.controllersProvider = moduleSeed.controllersProvider
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
        self.transitionsCoordinator = moduleSeed.transitionsCoordinator
        self.transitionIdGenerator = moduleSeed.transitionIdGenerator
        self.controllersProvider = moduleSeed.controllersProvider
    }
}