import Marshroute

final class TrackedModulesList {
    // MARK: - Private properties
    private var modules = [TrackedModule]()
    
    // MARK: - Internal
    func append(_ trackedModule: TrackedModule) {
        guard trackedModule.weakTransitionsHandlerBox.unbox() !== nil
            else { return }
        
        releaseZombieModules()
        
        guard !modules.contains(where: { $0.transitionId == trackedModule.transitionId })
            else { return }
        
        modules.append(trackedModule)
    }
    
    func removeTrackedModuleWithTransitionUserId(
        _ transitionUserId: TransitionUserId,
        transitionId: TransitionId)
    {
        releaseZombieModules()
        
        let index = modules.firstIndex {
            ($0.transitionUserId == transitionUserId) &&
                ($0.transitionId == transitionId)
        }
        
        if let trackedModuleIndex = index {
            modules.remove(at: trackedModuleIndex)
        }
    }
    
    func removeTrackedModulesWithTransitionUserId(_ transitionUserId: TransitionUserId) {
        releaseZombieModules()
        
        let index = modules.firstIndex { $0.transitionUserId == transitionUserId }
        
        if let trackedModuleIndex = index {
            modules.remove(at: trackedModuleIndex)
        }

    }

    func trackedModulesWithTransitionUserId(
        _ transitionUserId: TransitionUserId,
        mismatchingTransitionId transitionId: TransitionId)
        -> [TrackedModule]
    {
        releaseZombieModules()
        
        let result = modules.filter {
            ($0.transitionUserId == transitionUserId) &&
                ($0.transitionId != transitionId)
        }
        
        return result
    }
    
    func trackedModulesWithTransitionUserId(_ transitionUserId: TransitionUserId)
        -> [TrackedModule]
    {
        releaseZombieModules()
        
        let result = modules.filter { $0.transitionUserId == transitionUserId }
        
        return result
    }
    
    // MARK: - Private
    private func releaseZombieModules() {
        modules = modules.filter { $0.weakTransitionsHandlerBox.unbox() !== nil }
    }
}
