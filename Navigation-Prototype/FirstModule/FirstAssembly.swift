import UIKit

protocol FirstAssembly {
    func iphoneModule(
        title title: String,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionId: TransitionId,
        transitionsHandlerBox: RouterTransitionsHandlerBox,
        canShowFirstModule: Bool,
        canShowSecondModule: Bool,
        dismissable: Bool,
        withTimer: Bool,
        transitionsCoordinator: TransitionsCoordinator,
        transitionIdGenerator: TransitionIdGenerator)
        -> UIViewController
    
    func ipadDetailModule(
        title title: String,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionId: TransitionId,
        transitionsHandlerBox: RouterTransitionsHandlerBox,
        canShowFirstModule: Bool,
        canShowSecondModule: Bool,
        dismissable: Bool,
        withTimer: Bool,
        transitionsCoordinator: TransitionsCoordinator,
        transitionIdGenerator: TransitionIdGenerator)
        -> UIViewController
    
    func ipadMasterModule(
        title title: String,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionId: TransitionId,
        transitionsHandlerBox: RouterTransitionsHandlerBox,
        detailTransitionsHandlerBox: RouterTransitionsHandlerBox,
        canShowFirstModule: Bool,
        canShowSecondModule: Bool,
        dismissable: Bool,
        withTimer: Bool,
        transitionsCoordinator: TransitionsCoordinator,
        transitionIdGenerator: TransitionIdGenerator)
        -> UIViewController
}