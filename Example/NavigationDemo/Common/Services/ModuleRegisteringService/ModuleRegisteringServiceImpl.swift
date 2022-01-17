import Marshroute

private let authorizationModuleUserId = "AuthorizationModuleUserId"

final class ModuleRegisteringServiceImpl:
    ModuleRegisteringService,
    ModuleTrackingService,
    AuthorizationModuleRegisteringService,
    AuthorizationModuleTrackingService,
    TransitionsCoordinatorDelegate
{
    // MARK: - Private properties
    private let moduleList = TrackedModulesList()

    private let transitionsTracker: TransitionsTracker
    private let transitionsMarker: TransitionsMarker
    private let distanceThresholdBetweenSiblingModules: Int
    private let rootTransitionsHandlerProvider: (() -> (ContainingTransitionsHandler?))
    
    // MARK: - Init
    init(transitionsTracker: TransitionsTracker,
         transitionsMarker: TransitionsMarker,
         distanceThresholdBetweenSiblingModules: Int,
         rootTransitionsHandlerProvider: @escaping (() -> (ContainingTransitionsHandler?)))
    {
        self.transitionsTracker = transitionsTracker
        self.transitionsMarker = transitionsMarker
        self.distanceThresholdBetweenSiblingModules = distanceThresholdBetweenSiblingModules
        self.rootTransitionsHandlerProvider = rootTransitionsHandlerProvider
    }
    
    // MARK: - ModuleRegisteringService
    func registerTrackedModule(_ trackedModule: TrackedModule) {
        moduleList.append(trackedModule)
        
        transitionsMarker.markTransitionId(
            trackedModule.transitionId,
            withUserId: trackedModule.transitionUserId
        )
    }
    
    // MARK: - ModuleTrackingService
    func doesTrackedModuleExistInHistory(_ trackedModule: TrackedModule) -> Bool? {
        guard let rootTransitionsHandler = rootTransitionsHandlerProvider()
            else { return nil }
        
        guard let trackedTransition = trackedModule.trackedTransition()
            else { return false }
        
        let restoredTransition = transitionsTracker.restoredTransitionFromTrackedTransition(
            trackedTransition,
            searchingFromTransitionsHandler: rootTransitionsHandler
        )
        
        return restoredTransition != nil
    }
    
    // MARK: - AuthorizationModuleRegisteringService
    func registerAuthorizationModuleAsBeingTracked(
        transitionsHandlerBox: TransitionsHandlerBox,
        transitionId: TransitionId)
    {
        let trackedModule = TrackedModule(
            transitionsHandlerBox: transitionsHandlerBox,
            transitionId: transitionId,
            transitionUserId: authorizationModuleUserId
        )
        
        moduleList.removeTrackedModulesWithTransitionUserId(
            trackedModule.transitionUserId
        )
        
        registerTrackedModule(trackedModule)
    }
    
    // MARK: - AuthorizationModuleTrackingService
    func isAuthorizationModulePresented() -> Bool {
        let authorizationModules = moduleList.trackedModulesWithTransitionUserId(authorizationModuleUserId)
        
        guard let authorizationTrackedModule = authorizationModules.first
            else { return false }  // must be one o zero items in array
        
        return doesTrackedModuleExistInHistory(authorizationTrackedModule) ?? false
    }
    
    // MARK: - TransitionsCoordinatorDelegate
    func transitionsCoordinator(
        coordinator: TransitionsCoordinator,
        canForceTransitionsHandler transitionsHandler: TransitionsHandler,
        toLaunchResettingAnimationOfTransition context: ResettingTransitionContext,
        markedWithUserId userId: TransitionUserId)
        -> Bool
    {
        return true
    }
    
    func transitionsCoordinator(
        coordinator: TransitionsCoordinator,
        canForceTransitionsHandler transitionsHandler: TransitionsHandler,
        toLaunchPresentationAnimationOfTransition context: PresentationTransitionContext,
        markedWithUserId userId: TransitionUserId)
        -> Bool
    {
        if distanceThresholdBetweenSiblingModules == 0 {
            return true
        }
        
        // Search for modules with a passed `userId`
        let modulesMatchingUserId = moduleList.trackedModulesWithTransitionUserId(
            userId,
            mismatchingTransitionId: context.transitionId // except for the one we are transitioning to
        )
        
        for trackedModule in modulesMatchingUserId.reversed() {
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
                trackedModule.weakTransitionsHandlerBox.unbox()?.undoTransitionsAfter(
                    transitionId: trackedModule.transitionId
                )
                
                return result
            }
        }
        
        return true
    }
    
    func transitionsCoordinator(
        coordinator: TransitionsCoordinator,
        canUndoChainedTransition chainedTransition: RestoredTransitionContext?,
        andPushTransitions pushTransitions: [RestoredTransitionContext]?,
        forTransitionsHandler animatingTransitionsHandler: AnimatingTransitionsHandler,
        transitionId: TransitionId)
        -> Bool
    {
        return true
    }
    
    func transitionsCoordinator(
        coordinator: TransitionsCoordinator,
        willForceTransitionsHandler transitionsHandler: TransitionsHandler,
        toLaunchResettingAnimationOfTransition context: ResettingTransitionContext)
    {}
    
    func transitionsCoordinator(
        coordinator: TransitionsCoordinator,
        willForceTransitionsHandler transitionsHandler: TransitionsHandler,
        toLaunchPresentationAnimationOfTransition context: PresentationTransitionContext)
    {}
    
    func transitionsCoordinator(
        coordinator: TransitionsCoordinator,
        willForceTransitionsHandler transitionsHandler: TransitionsHandler,
        toLaunchDismissalAnimationByAnimator animatorBox: TransitionsAnimatorBox,
        ofTransitionsAfterId transitionId: TransitionId)
    {}
    
    func transitionsCoordinator(
        coordinator: TransitionsCoordinator,
        willForceTransitionsHandler transitionsHandler: TransitionsHandler,
        toLaunchDismissalAnimationByAnimator animatorBox: TransitionsAnimatorBox,
        ofTransitionWithId transitionId: TransitionId)
    {}
}
