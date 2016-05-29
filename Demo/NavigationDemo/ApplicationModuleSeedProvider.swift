import AvitoNavigation

final class ApplicationModuleSeedProvider {
    func applicationModuleSeed(avitoNavigationSetupService avitoNavigationSetupService: AvitoNavigationSetupService)
        -> ApplicationModuleSeed
    {
        let avitoStack = avitoNavigationSetupService.avitoNavigationStack()
        
        let transitionId = avitoStack.transitionIdGenerator.generateNewTransitionId()
        
        let result = ApplicationModuleSeed(
            transitionId: transitionId,
            presentingTransitionsHandler: nil,
            avitoNavigationStack: avitoStack
        )
        
        return result
    }
}