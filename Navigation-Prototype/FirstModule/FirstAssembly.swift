import Foundation

protocol FirstAssembly {
    func iphoneModule(
        title: String,
        parentTransitionsHandler: TransitionsHandler?,
        transitionId: TransitionId,
        transitionsHandler: TransitionsHandler,
        canShowFirstModule: Bool,
        canShowSecondModule: Bool,
        dismissable: Bool,
        withTimer: Bool)
        -> (FirstViewController, FirstModuleInput)
    
    func ipadDetailModule(
        title: String,
        parentTransitionsHandler: TransitionsHandler?,
        transitionId: TransitionId,
        transitionsHandler: TransitionsHandler,
        canShowFirstModule: Bool,
        canShowSecondModule: Bool,
        dismissable: Bool,
        withTimer: Bool)
        -> (FirstViewController, FirstModuleInput)
    
    func ipadMasterModule(
        title: String,
        parentTransitionsHandler: TransitionsHandler?,
        transitionId: TransitionId,
        transitionsHandler: TransitionsHandler,
        detailTransitionsHandler: TransitionsHandler,
        canShowFirstModule: Bool,
        canShowSecondModule: Bool,
        dismissable: Bool,
        withTimer: Bool)
        -> (FirstViewController, FirstModuleInput)
    
}
