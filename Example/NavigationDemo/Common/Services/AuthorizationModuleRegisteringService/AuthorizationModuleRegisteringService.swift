import Marshroute

protocol AuthorizationModuleRegisteringService: AnyObject {
    func registerAuthorizationModuleAsBeingTracked(
        transitionsHandlerBox: TransitionsHandlerBox,
        transitionId: TransitionId)
}
