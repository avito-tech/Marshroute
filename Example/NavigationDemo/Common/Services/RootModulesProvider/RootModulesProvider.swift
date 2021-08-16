import Marshroute

protocol RootModulesProvider: AnyObject {
    func detailModule(
        moduleSeed: ApplicationModuleSeed,
        deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController)
        -> (navigationController: UINavigationController, animatingTransitionsHandler: AnimatingTransitionsHandler)
    
    func masterDetailModule(
        moduleSeed: ApplicationModuleSeed,
        deriveMasterViewController: (_ routerSeed: MasterDetailRouterSeed) -> UIViewController,
        deriveDetailViewController: (_ routerSeed: RouterSeed) -> UIViewController)
        -> (splitViewController: UISplitViewController, containingTransitionsHandler: ContainingTransitionsHandler)
}
    
