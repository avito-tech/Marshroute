public typealias InstantiateTabViewControllers = (() -> ())

public typealias DeriveTabBarController = ((RouterSeed, InstantiateTabViewControllers) -> (UITabBarController))

/// Defines a type of function to create a view controller for some tab of `UITabBarController`  
public enum TabViewControllerDeriviationFunctionType {
    /// Creates a regular `UIViewController` (probably wrapped into `UINavigationController`) 
    case detailController(DetailViewControllerDeriviationFunctionType)
    
    /// Creates a master-detail view controller (`UISplitViewController`)
    /// Both master and detail view controllers may be wrapped into `UINavigationController` 
    case masterDetailViewController(MasterDetailViewControllerDeriviationFuctionType)
    
    // MARK: - Convenience functions
    
    // MARK: Detail view controller
    public static func deriveDetailViewController(
        _ deriveDetailViewController: @escaping DeriveDetailViewController)
        -> TabViewControllerDeriviationFunctionType
    {
        return .detailController(
            .controller(deriveDetailViewController)
        )
    }
    
    public static func deriveDetailViewControllerInNavigationController(
        _ deriveDetailViewController: @escaping DeriveDetailViewController)
        -> TabViewControllerDeriviationFunctionType
    {
        return .detailController(
            .controllerInNavigationController(deriveDetailViewController)
        )
    }
    
    // MARK: MasterDetail view controller. Master and Detail not in UINavigationController
    public static func derive(
        masterDetailViewController: @escaping DeriveMasterDetailViewController,
        masterViewController: @escaping DeriveMasterViewController,
        detailViewController: @escaping DeriveDetailViewController)
        -> TabViewControllerDeriviationFunctionType
    {
        return .masterDetailViewController(
            MasterDetailViewControllerDeriviationFuctionType(
                deriveMasterDetailViewController: masterDetailViewController,
                masterFunctionType: .controller(masterViewController),
                detailFunctionType: .controller(detailViewController)
            )
        )
    }
    
    public static func deriveMasterDetailViewController(
        masterViewController: @escaping DeriveMasterViewController,
        detailViewController: @escaping DeriveDetailViewController)
        -> TabViewControllerDeriviationFunctionType
    {
        return .masterDetailViewController(
            MasterDetailViewControllerDeriviationFuctionType(
                deriveMasterDetailViewController: nil,
                masterFunctionType: .controller(masterViewController),
                detailFunctionType: .controller(detailViewController)
            )
        )
    }
    
    // MARK: MasterDetail view controller. Master in UINavigationController. Detail not in UINavigationController
    public static func derive(
        masterDetailViewController: @escaping DeriveMasterDetailViewController,
        masterViewControllerInNavigationController: @escaping DeriveMasterViewController,
        detailViewController: @escaping DeriveDetailViewController)
        -> TabViewControllerDeriviationFunctionType
    {
        return .masterDetailViewController(
            MasterDetailViewControllerDeriviationFuctionType(
                deriveMasterDetailViewController: masterDetailViewController,
                masterFunctionType: .controllerInNavigationController(masterViewControllerInNavigationController),
                detailFunctionType: .controller(detailViewController)
            )
        )
    }
    
    public static func deriveMasterDetailViewController(
        masterViewControllerInNavigationController: @escaping DeriveMasterViewController,
        detailViewController: @escaping DeriveDetailViewController)
        -> TabViewControllerDeriviationFunctionType
    {
        return .masterDetailViewController(
            MasterDetailViewControllerDeriviationFuctionType(
                deriveMasterDetailViewController: nil,
                masterFunctionType: .controllerInNavigationController(masterViewControllerInNavigationController),
                detailFunctionType: .controller(detailViewController)
            )
        )
    }

    // MARK: MasterDetail view controller. Detail in UINavigationController. Master not in UINavigationController
    public static func derive(
        masterDetailViewController: @escaping DeriveMasterDetailViewController,
        masterViewController: @escaping DeriveMasterViewController,
        detailViewControllerInNavigationController: @escaping DeriveDetailViewController)
        -> TabViewControllerDeriviationFunctionType
    {
        return .masterDetailViewController(
            MasterDetailViewControllerDeriviationFuctionType(
                deriveMasterDetailViewController: masterDetailViewController,
                masterFunctionType: .controller(masterViewController),
                detailFunctionType: .controllerInNavigationController(detailViewControllerInNavigationController)
            )
        )
    }
    
    public static func deriveMasterDetailViewController(
        masterViewController: @escaping DeriveMasterViewController,
        detailViewControllerInNavigationController: @escaping DeriveDetailViewController)
        -> TabViewControllerDeriviationFunctionType
    {
        return .masterDetailViewController(
            MasterDetailViewControllerDeriviationFuctionType(
                deriveMasterDetailViewController: nil,
                masterFunctionType: .controller(masterViewController),
                detailFunctionType: .controllerInNavigationController(detailViewControllerInNavigationController)
            )
        )
    }
    
    // MARK: MasterDetail view controller. Master and Detail in UINavigationController
    public static func derive(
        masterDetailViewController: @escaping DeriveMasterDetailViewController,
        masterViewControllerInNavigationController: @escaping DeriveMasterViewController,
        detailViewControllerInNavigationController: @escaping DeriveDetailViewController)
        -> TabViewControllerDeriviationFunctionType
    {
        return .masterDetailViewController(
            MasterDetailViewControllerDeriviationFuctionType(
                deriveMasterDetailViewController: masterDetailViewController,
                masterFunctionType: .controllerInNavigationController(masterViewControllerInNavigationController),
                detailFunctionType: .controllerInNavigationController(detailViewControllerInNavigationController)
            )
        )
    }
    
    public static func deriveMasterDetailViewController(
        masterViewControllerInNavigationController: @escaping DeriveMasterViewController,
        detailViewControllerInNavigationController: @escaping DeriveDetailViewController)
        -> TabViewControllerDeriviationFunctionType
    {
        return .masterDetailViewController(
            MasterDetailViewControllerDeriviationFuctionType(
                deriveMasterDetailViewController: nil,
                masterFunctionType: .controllerInNavigationController(masterViewControllerInNavigationController),
                detailFunctionType: .controllerInNavigationController(detailViewControllerInNavigationController)
            )
        )
    }
}
