import UIKit

protocol FirstAssembly {
    func iphoneModule(
        title title: String,
        canShowFirstModule: Bool,
        canShowSecondModule: Bool,
        dismissable: Bool,
        withTimer: Bool,
        routerSeed: BaseRouterSeed)
        -> UIViewController
    
    func ipadDetailModule(
        title title: String,
        canShowFirstModule: Bool,
        canShowSecondModule: Bool,
        dismissable: Bool,
        withTimer: Bool,
        routerSeed: BaseRouterSeed)
        -> UIViewController
    
    func ipadMasterModule(
        title title: String,
        canShowFirstModule: Bool,
        canShowSecondModule: Bool,
        dismissable: Bool,
        withTimer: Bool,
        routerSeed: BaseRouterSeed,
        detailTransitionsHandlerBox: RouterTransitionsHandlerBox)
        -> UIViewController
}