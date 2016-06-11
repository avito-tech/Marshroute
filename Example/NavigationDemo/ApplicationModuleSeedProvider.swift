import Marshroute

final class ApplicationModuleSeedProvider {
    func applicationModuleSeed(marshrouteSetupService marshrouteSetupService: MarshrouteSetupService)
        -> ApplicationModuleSeed
    {
        let marshrouteStack = marshrouteSetupService.marshrouteStack()
        
        let transitionId = marshrouteStack.transitionIdGenerator.generateNewTransitionId()
        
        let result = ApplicationModuleSeed(
            transitionId: transitionId,
            presentingTransitionsHandler: nil,
            marshrouteStack: marshrouteStack
        )
        
        return result
    }
}