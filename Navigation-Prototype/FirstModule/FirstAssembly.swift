import Foundation

protocol FirstAssembly {
    func iphoneModule(
        title: String,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionId: TransitionId,
        transitionsHandler: TransitionsHandler,
        canShowFirstModule: Bool,
        canShowSecondModule: Bool,
        dismissable: Bool,
        withTimer: Bool,
        transitionsCoordinator: TransitionsCoordinator)
        -> (FirstViewController, FirstModuleInput)
    
    func ipadDetailModule(
        title: String,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionId: TransitionId,
        transitionsHandler: TransitionsHandler,
        canShowFirstModule: Bool,
        canShowSecondModule: Bool,
        dismissable: Bool,
        withTimer: Bool,
        transitionsCoordinator: TransitionsCoordinator)
        -> (FirstViewController, FirstModuleInput)
    
    func ipadMasterModule(
        title: String,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionId: TransitionId,
        transitionsHandler: TransitionsHandler,
        detailTransitionsHandler: TransitionsHandler,
        canShowFirstModule: Bool,
        canShowSecondModule: Bool,
        dismissable: Bool,
        withTimer: Bool,
        transitionsCoordinator: TransitionsCoordinator)
        -> (FirstViewController, FirstModuleInput)
    
}
