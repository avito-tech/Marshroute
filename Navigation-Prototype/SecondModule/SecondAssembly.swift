import UIKit

protocol SecondAssembly {
    func iphoneModule(
        transitionsHandler: TransitionsHandler,
        title: String,
        withTimer: Bool,
        canShowModule1: Bool,
        transitionId: TransitionId?,
        parentTransitionsHandler: TransitionsHandler?)
        -> (UIViewController, SecondModuleInput)
    
    func ipadModule(
        transitionsHandler: TransitionsHandler,
        title: String,
        withTimer: Bool,
        canShowModule1: Bool,
        transitionId: TransitionId?,
        parentTransitionsHandler: TransitionsHandler?)
        -> (UIViewController, SecondModuleInput)
}
