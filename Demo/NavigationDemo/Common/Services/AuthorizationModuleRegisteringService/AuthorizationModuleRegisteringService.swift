import AvitoNavigation

protocol AuthorizationModuleRegisteringService: class {
    func registerAuthorizationModuleAsBeingTracked(
        transitionsHandlerBox transitionsHandlerBox: TransitionsHandlerBox,
        transitionId: TransitionId)
}
