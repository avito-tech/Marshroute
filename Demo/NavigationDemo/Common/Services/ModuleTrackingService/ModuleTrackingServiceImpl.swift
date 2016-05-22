import AvitoNavigation

final class ModuleTrackingServiceImpl: ModuleTrackingService, TransitionsCoordinatorDelegate {
    // MARK: - Private properties
    private let moduleList = TrackedModulesList()

    private let transitionsTracker: TransitionsTracker
    private let transitionsMarker: TransitionsMarker
    private let distanceThresholdBetweenSiblingModules: Int
    
    // MARK: - Init
    init(transitionsTracker: TransitionsTracker,
         transitionsMarker: TransitionsMarker,
         distanceThresholdBetweenSiblingModules: Int)
    {
        self.transitionsTracker = transitionsTracker
        self.transitionsMarker = transitionsMarker
        self.distanceThresholdBetweenSiblingModules = distanceThresholdBetweenSiblingModules
    }
    
    // MARK: - ModuleTrackingService
    func registerTrackedModule(trackedModule: TrackedModule) {
        moduleList.append(trackedModule)
        
        transitionsMarker.markTransitionId(
            trackedModule.transitionId,
            withUserId: trackedModule.transitionUserId
        )
    }
    
    // MARK: - TransitionsCoordinatorDelegate
    func transitionsCoordinator(
        coordinator coordinator: TransitionsCoordinator,
        canForceTransitionsHandler transitionsHandler: TransitionsHandler,
        toLaunchResettingAnimationOfTransition context: ResettingTransitionContext,
        markedWithUserId userId: TransitionUserId)
        -> Bool
    {
        return true
    }
    
    func transitionsCoordinator(
        coordinator coordinator: TransitionsCoordinator,
        canForceTransitionsHandler transitionsHandler: TransitionsHandler,
        toLaunchPresentationAnimationOfTransition context: PresentationTransitionContext,
        markedWithUserId userId: TransitionUserId)
        -> Bool
    {
        if distanceThresholdBetweenSiblingModules == 0 {
            return true
        }
        
        // Search for modules with a passed `userId`
        let modulesMatchingUserId = moduleList.trackedModuleWithTransitionUserId(
            userId,
            mismatchingTransitionId: context.transitionId // except for the one we are transitioning to
        )
        
        for trackedModule in modulesMatchingUserId.reverse() {
            guard let trackedTransition = trackedModule.trackedTransition()
                else { continue }
            
            // Compute the distance between a sibling module up to a currenly visible module 
            let countOfTransitions = transitionsTracker.countOfTransitionsAfterTrackedTransition(
                trackedTransition,
                untilLastTransitionOfTransitionsHandler: transitionsHandler
            )
            
            guard let distance = countOfTransitions
                else { continue }
            
            // debugPrint("Count of transitions after \(trackedModule.transitionUserId) is \(distance)")
            
            if distance != 0 && distance <= distanceThresholdBetweenSiblingModules {
                // Will no allow transitioning to a sibling module
                let result = false
                
                // Delete the tracked module, because we will not allow transitioning to it
                moduleList.removeTrackedModuleWithTransitionUserId(
                    userId,
                    transitionId: context.transitionId
                )
                
                // Return to a previous sibling module
                trackedModule.weakTransitionsHandlerBox?.unbox()?.undoTransitionsAfter(
                    transitionId: trackedModule.transitionId
                )
                
                return result
            }
        }
        
        return true
    }
    
    func transitionsCoordinator(
        coordinator coordinator: TransitionsCoordinator,
        willForceTransitionsHandler transitionsHandler: TransitionsHandler,
        toLaunchResettingAnimationOfTransition context: ResettingTransitionContext)
    {}
    
    func transitionsCoordinator(
        coordinator coordinator: TransitionsCoordinator,
        willForceTransitionsHandler transitionsHandler: TransitionsHandler,
        toLaunchPresentationAnimationOfTransition context: PresentationTransitionContext)
    {}
    
    func transitionsCoordinator(
        coordinator coordinator: TransitionsCoordinator,
        willForceTransitionsHandler transitionsHandler: TransitionsHandler,
        toLaunchDismissalAnimationByAnimator animatorBox: TransitionsAnimatorBox,
        ofTransitionsAfterId transitionId: TransitionId)
    {}
    
    func transitionsCoordinator(
        coordinator coordinator: TransitionsCoordinator,
        willForceTransitionsHandler transitionsHandler: TransitionsHandler,
        toLaunchDismissalAnimationByAnimator animatorBox: TransitionsAnimatorBox,
        ofTransitionWithId transitionId: TransitionId)
    {}
}