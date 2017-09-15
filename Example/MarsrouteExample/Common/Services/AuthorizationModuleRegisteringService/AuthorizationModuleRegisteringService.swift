import Marshroute

protocol AuthorizationModuleRegisteringService: class {
    func registerAuthorizationModuleAsBeingTracked(
        transitionsHandlerBox: TransitionsHandlerBox,
        transitionId: TransitionId)
}
