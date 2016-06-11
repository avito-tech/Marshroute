import Marshroute

final class ApplicationModuleSeedProvider {
    func applicationModuleSeed(marshrouteNavigationSetupService marshrouteNavigationSetupService: MarshrouteNavigationSetupService)
        -> ApplicationModuleSeed
    {
        let marshrouteStack = marshrouteNavigationSetupService.marshrouteNavigationStack()
        
        let transitionId = marshrouteStack.transitionIdGenerator.generateNewTransitionId()
        
        let result = ApplicationModuleSeed(
            transitionId: transitionId,
            presentingTransitionsHandler: nil,
            marshrouteNavigationStack: marshrouteStack
        )
        
        return result
    }
}