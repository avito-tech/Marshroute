import UIKit

protocol SecondAssembly {
    func iphoneModule(
        transitionsHandlerBox transitionsHandlerBox: RouterTransitionsHandlerBox,
        title: String,
        withTimer: Bool,
        canShowModule1: Bool,
        transitionId: TransitionId,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionsCoordinator: TransitionsCoordinator,
        transitionIdGenerator: TransitionIdGenerator)
        -> UIViewController
    
    func ipadModule(
        transitionsHandlerBox transitionsHandlerBox: RouterTransitionsHandlerBox,
        title: String,
        withTimer: Bool,
        canShowModule1: Bool,
        transitionId: TransitionId,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionsCoordinator: TransitionsCoordinator,
        transitionIdGenerator: TransitionIdGenerator)
        -> UIViewController
}