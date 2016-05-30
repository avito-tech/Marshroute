import Marshroute

protocol AuthorizationModuleRegisteringService: class {
    func registerAuthorizationModuleAsBeingTracked(
        transitionsHandlerBox transitionsHandlerBox: TransitionsHandlerBox,
        transitionId: TransitionId)
}
