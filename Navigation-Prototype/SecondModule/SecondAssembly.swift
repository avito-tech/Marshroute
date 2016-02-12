import UIKit

protocol SecondAssembly {
    func iphoneModule(
        title title: String,
        withTimer: Bool,
        canShowModule1: Bool,
        routerSeed: BaseRouterSeed)
        -> UIViewController
    
    func ipadModule(
        title title: String,
        withTimer: Bool,
        canShowModule1: Bool,
        routerSeed: BaseRouterSeed)
        -> UIViewController
}