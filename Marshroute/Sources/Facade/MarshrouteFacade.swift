import UIKit

public final class MarshrouteFacade {
    // MARK: - Private properties
    private let marshrouteStack: MarshrouteStack
    private let viewControllerDeriver: ViewControllerDeriver
    
    // MARK: - Init
    public convenience init(
        marshrouteSetupService: MarshrouteSetupService)
    {
        self.init(
            marshrouteStack: marshrouteSetupService.marshrouteStack()
        )
    }
    
    public init(marshrouteStack: MarshrouteStack) {
        self.marshrouteStack = marshrouteStack
        
        let routerSeedMaker = SingleTransitionIdRouterSeedMaker(
            marshrouteStack: marshrouteStack
        )
        
        self.viewControllerDeriver = ViewControllerDeriver(
            routerSeedMaker: routerSeedMaker,
            marshrouteStack: marshrouteStack
        )
    }
    
    // MARK: - Public
    public func navigationModule(
        _ navigationController: UINavigationController? = nil,
        withRootViewControllerDerivedFrom deriveViewController: (RouterSeed) -> (UIViewController))
        -> MarshrouteModule<UINavigationController>
    {
        let (_, navigationController, routerSeed) = viewControllerDeriver.deriveDetailViewControllerInNavigationControllerFrom(
            deriveDetailViewController: deriveViewController,
            navigationController: navigationController
        )
        
        return MarshrouteModule<UINavigationController>(
            viewController: navigationController,
            routerSeed: routerSeed
        )
    }
    
    public func splitModule(
        masterDetailViewControllerDeriviationFuctionType: MasterDetailViewControllerDeriviationFuctionType)
        -> MarshrouteModule<UISplitViewController>
    {
        let (splitViewController, routerSeed) = viewControllerDeriver.deriveMasterDetailViewControllerFrom(
            masterDetailViewControllerDeriviationFuctionType: masterDetailViewControllerDeriviationFuctionType
        )
        
        return MarshrouteModule<UISplitViewController>(
            viewController: splitViewController,
            routerSeed: routerSeed
        )
    }
 
    public func tabBarModule(
        tabViewControllerDeriviationFunctions: [TabViewControllerDeriviationFunctionType],
        deriveTabBarController: DeriveTabBarController? = nil)
        -> MarshrouteModule<UITabBarController>
    {
        // TODO: use parameters?
        let (tabBarController, _, routerSeed, _) = viewControllerDeriver.tabBarModule(
            tabViewControllerDeriviationFunctions: tabViewControllerDeriviationFunctions,
            deriveTabBarController: deriveTabBarController
        )
        
        return MarshrouteModule<UITabBarController>(
            viewController: tabBarController,
            routerSeed: routerSeed
        )
    }
}
