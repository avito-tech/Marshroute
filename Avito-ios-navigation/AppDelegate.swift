import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
}


// в обычный модуль (управляющий одним UINavigationController'ом)
// из другого обычного модуля
// или из Master-Detail модуля (управляющего двумя UINavigationController'ами)
// (подходит для iPhone- и для iPad-модулей, т.к. сейчас UIPopoverController есть и на iPhone, и на iPad)
protocol ToModuleGuideable: class {
    typealias ModuleSeedType

    func pushToModule(moduleSeed moduleSeed: ModuleSeedType)
    func modalToModule(moduleSeed moduleSeed: ModuleSeedType)
    func resetToModule(moduleSeed moduleSeed: ModuleSeedType)
    func popoverToModule(moduleSeed moduleSeed: ModuleSeedType, fromView view: UIView, inRect rect: CGRect)
    func popoverToModule(moduleSeed moduleSeed: ModuleSeedType, fromBarButtonItem buttonItem: UIBarButtonItem)
}

protocol ToModuleWithModuleInputGuideable: class {
    typealias ModuleSeedType
    typealias ModuleInputType

    func pushToModule(moduleSeed moduleSeed: ModuleSeedType, captureModuleInput: ((moduleInput: ModuleInputType) -> Void))
    func modalToModule(moduleSeed moduleSeed: ModuleSeedType, captureModuleInput: ((moduleInput: ModuleInputType) -> Void))
    func resetToModule(moduleSeed moduleSeed: ModuleSeedType, captureModuleInput: ((moduleInput: ModuleInputType) -> Void))
    func popoverToModule(moduleSeed moduleSeed: ModuleSeedType, fromView view: UIView, inRect rect: CGRect, captureModuleInput: ((moduleInput: ModuleInputType) -> Void))
    func popoverToModule(moduleSeed moduleSeed: ModuleSeedType, fromBarButtonItem buttonItem: UIBarButtonItem, captureModuleInput: ((moduleInput: ModuleInputType) -> Void))
}

// в Master-Detail модуль (управляющий двумя UINavigationController'ами)
// из другого Master-Detail модуля
// (подходит для iPhone- и для iPad-модулей, т.к. сейчас UISplitViewController есть и на iPhone, и на iPad)
protocol ToMasterDetailModuleGuideable: class {
    typealias MasterDetailModuleSeedType
    
    func pushToModule(moduleSeed moduleSeed: MasterDetailModuleSeedType)
    func resetToModule(moduleSeed moduleSeed: MasterDetailModuleSeedType)
}

// в Detail модуль UISplitViewController'а (управляющего одним UINavigationController'ом)
// из Master-Detail модуля (управляющего двумя UINavigationController'ами)
// (подходит для iPhone- и для iPad-модулей, т.к. сейчас UISplitViewController есть и на iPhone, и на iPad)
protocol ToModuleFromMasterDetailGuideable: class {
    typealias ModuleSeedType
    
    func pushToModule(moduleSeed moduleSeed: ModuleSeedType)
    func resetToModule(moduleSeed moduleSeed: ModuleSeedType)
}


struct ChannelSeed {
    let channelId: String
}

final class ChannelAssembly {
    func createChannelViewController(moduleSeed moduleSeed: ChannelSeed, routerSeed: BaseRouterSeed) -> UIViewController {
        return UIViewController()
    }
    
    func createChannelViewController(moduleSeed moduleSeed: ChannelSeed, routerSeed: BaseMasterDetailRouterSeed) -> UIViewController {
        return UIViewController()
    }

}

protocol ToChannelGuideable: ToModuleGuideable {
    typealias ModuleSeedType = ChannelSeed
}

extension ToChannelGuideable where Self: DetailRouter {
    func pushToModule(moduleSeed moduleSeed: ChannelSeed)
    {
        pushViewControllerDerivedFrom { (routerSeed) -> UIViewController in
            let channelAssembly = ChannelAssembly()

            let viewController = channelAssembly.createChannelViewController(moduleSeed: moduleSeed, routerSeed: routerSeed)

            return viewController
        }
    }
}

protocol ToMasterDetailChannelGuideable: ToMasterDetailModuleGuideable {
    typealias MasterDetailModuleSeedType = ChannelSeed
}

protocol ToChannelFromMasterDetailGuideable {
    typealias ModuleSeedType = ChannelSeed
}

protocol ChannelsRouterInput: class {
    func showChannel(moduleSeed moduleSeed: ChannelSeed)
}

final class ChannelsRouter: BaseRouter, ChannelsRouterInput, ToChannelGuideable {
    func showChannel(moduleSeed moduleSeed: ChannelSeed) {
        pushToModule(moduleSeed: moduleSeed)
    }
}