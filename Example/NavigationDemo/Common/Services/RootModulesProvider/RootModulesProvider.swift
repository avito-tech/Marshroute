import AvitoNavigation

protocol RootModulesProvider: class {
    func detailModule(
        moduleSeed moduleSeed: ApplicationModuleSeed,
        @noescape deriveViewController: (routerSeed: RouterSeed) -> UIViewController)
        -> (navigationController: UINavigationController, animatingTransitionsHandler: AnimatingTransitionsHandler)
    
    func masterDetailModule(
        moduleSeed moduleSeed: ApplicationModuleSeed,
        @noescape deriveMasterViewController: (routerSeed: MasterDetailRouterSeed) -> UIViewController,
        @noescape deriveDetailViewController: (routerSeed: RouterSeed) -> UIViewController)
        -> (splitViewController: UISplitViewController, containingTransitionsHandler: ContainingTransitionsHandler)
}
    