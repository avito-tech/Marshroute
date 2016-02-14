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
    
    func ipadModule(
        title title: String,
        canShowFirstModule: Bool,
        canShowSecondModule: Bool,
        dismissable: Bool,
        withTimer: Bool,
        routerSeed: BaseRouterSeed)
        -> UIViewController
    
    func ipadMasterDetailModule(
        title title: String,
        canShowFirstModule: Bool,
        canShowSecondModule: Bool,
        dismissable: Bool,
        withTimer: Bool,
        routerSeed: BaseMasterDetailRouterSeed)
        -> UIViewController
}