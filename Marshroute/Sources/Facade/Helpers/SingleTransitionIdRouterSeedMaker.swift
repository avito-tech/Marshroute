public final class SingleTransitionIdRouterSeedMaker {
    // MARK: - Private properties
    private let transitionId: TransitionId
    private let marshrouteStack: MarshrouteStack
    
    // MARK: - Init
    public init(marshrouteStack: MarshrouteStack) {
        self.transitionId = marshrouteStack.transitionIdGenerator.generateNewTransitionId()
        self.marshrouteStack = marshrouteStack
    }
    
    // MARK: - Detail modules
    public func makeRouterSeed(
        animatingTransitionsHandler: AnimatingTransitionsHandler,
        presentingTransitionsHandler: TransitionsHandler? = nil)
        -> RouterSeed
    {
        return makeRouterSeed(
            transitionsHandlerBox: .init(animatingTransitionsHandler: animatingTransitionsHandler),
            presentingTransitionsHandler: presentingTransitionsHandler
        )
    }
    
    public func makeRouterSeed(
        containingTransitionsHandler: ContainingTransitionsHandler,
        presentingTransitionsHandler: TransitionsHandler? = nil)
        -> RouterSeed
    {
        return makeRouterSeed(
            transitionsHandlerBox: .init(containingTransitionsHandler: containingTransitionsHandler),
            presentingTransitionsHandler: presentingTransitionsHandler
        )
    }
    
    public func makeRouterSeed(
        transitionsHandlerBox: TransitionsHandlerBox,
        presentingTransitionsHandler: TransitionsHandler? = nil)
        -> RouterSeed
    {
        return RouterSeed(
            transitionsHandlerBox: transitionsHandlerBox,
            transitionId: transitionId,
            presentingTransitionsHandler: presentingTransitionsHandler,
            transitionsHandlersProvider: marshrouteStack.transitionsHandlersProvider,
            transitionIdGenerator: marshrouteStack.transitionIdGenerator,
            controllersProvider: marshrouteStack.routerControllersProvider
        )
    }
    
    // MARK: - MasterDetail modules
    public func makeMasterDetailRouterSeed(
        masterAnimaingTransitionsHandler: AnimatingTransitionsHandler,
        detailTransitionsHandlerBox: TransitionsHandlerBox)
        -> MasterDetailRouterSeed
    {
        return makeMasterDetailRouterSeed(
            masterTransitionsHandlerBox: .init(animatingTransitionsHandler: masterAnimaingTransitionsHandler),
            detailTransitionsHandlerBox: detailTransitionsHandlerBox
        )
    }
    
    public func makeMasterDetailRouterSeed(
        masterTransitionsHandlerBox: TransitionsHandlerBox,
        detailTransitionsHandlerBox: TransitionsHandlerBox)
        -> MasterDetailRouterSeed
    {
        return MasterDetailRouterSeed(
            masterTransitionsHandlerBox: masterTransitionsHandlerBox,
            detailTransitionsHandlerBox: detailTransitionsHandlerBox,
            transitionId: transitionId,
            presentingTransitionsHandler: nil,
            transitionsHandlersProvider: marshrouteStack.transitionsHandlersProvider,
            transitionIdGenerator: marshrouteStack.transitionIdGenerator,
            controllersProvider: marshrouteStack.routerControllersProvider
        )
    }
}
