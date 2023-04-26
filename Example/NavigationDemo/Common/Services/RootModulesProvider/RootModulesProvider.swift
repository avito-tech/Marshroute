import Marshroute

struct NavigationModule {
    let navigationController: UINavigationController
    let navigationTransitionsHandler: NavigationTransitionsHandler
}

struct SplitViewModule {
    let splitViewController: SplitViewControllerProtocol & UIViewController
    let splitViewTransitionsHandler: SplitViewTransitionsHandler
}

protocol RootModulesProvider: AnyObject {
    func detailModule(
        moduleSeed: ApplicationModuleSeed,
        deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController)
        -> NavigationModule
    
    func masterDetailModule(
        moduleSeed: ApplicationModuleSeed,
        deriveMasterViewController: (_ routerSeed: MasterDetailRouterSeed) -> UIViewController,
        deriveDetailViewController: (_ routerSeed: RouterSeed) -> UIViewController)
        -> SplitViewModule
}
    
