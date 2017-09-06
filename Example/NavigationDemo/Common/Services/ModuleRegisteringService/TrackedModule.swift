import Marshroute

struct TrackedModule {
    let weakTransitionsHandlerBox: WeakTransitionsHandlerBox
    let transitionId: TransitionId
    let transitionUserId: TransitionUserId
    
    init(
        transitionsHandlerBox: TransitionsHandlerBox,
        transitionId: TransitionId,
        transitionUserId: TransitionUserId)
    {
        self.weakTransitionsHandlerBox = WeakTransitionsHandlerBox(
            transitionsHandlerBox: transitionsHandlerBox
        )
        
        self.transitionId = transitionId
        self.transitionUserId = transitionUserId
    }
}

extension TrackedModule {
    func trackedTransition() -> TrackedTransition? {
        guard let transitionsHandlerBox = weakTransitionsHandlerBox.transitionsHandlerBox()
            else { return nil }
        
        return TrackedTransition(
            transitionId: transitionId,
            transitionsHandlerBox: transitionsHandlerBox
        )
    }
}
