public enum TabControllerDeriviationFunctionType {
    case detailController(DetailViewControllerDeriviationFunctionType)
    case masterDetailViewController(MasterDetailViewControllerDeriviationFuctionType)
    
    // MARK: - Convenience functions
    public static func deriveDetailViewController(
        _ deriveDetailViewController: @escaping DeriveDetailViewController)
        -> TabControllerDeriviationFunctionType
    {
        return .detailController(
            .controller(deriveDetailViewController)
        )
    }
    
    public static func deriveDetailViewControllerInNavigationController(
        _ deriveDetailViewController: @escaping DeriveDetailViewController)
        -> TabControllerDeriviationFunctionType
    {
        return .detailController(
            .controllerInNavigationController(deriveDetailViewController)
        )
    }
    
    public static func deriveMasterDetailViewController(
        deriveMasterViewController: @escaping DeriveMasterViewController,
        deriveDetailViewController: @escaping DeriveDetailViewController)
        -> TabControllerDeriviationFunctionType
    {
        return .masterDetailViewController(
            MasterDetailViewControllerDeriviationFuctionType(
                masterFunctionType: .controller(deriveMasterViewController),
                detailFunctionType: .controller(deriveDetailViewController)
            )
        )
    }
    
    public static func derive(
        deriveMasterViewControllerInNavigationController: @escaping DeriveMasterViewController,
        deriveDetailViewController: @escaping DeriveDetailViewController)
        -> TabControllerDeriviationFunctionType
    {
        return .masterDetailViewController(
            MasterDetailViewControllerDeriviationFuctionType(
                masterFunctionType: .controllerInNavigationController(deriveMasterViewControllerInNavigationController),
                detailFunctionType: .controller(deriveDetailViewController)
            )
        )
    }
    
    public static func deriveMasterDetailViewController(
        deriveMasterViewController: @escaping DeriveMasterViewController,
        deriveDetailViewControllerInNavigationController: @escaping DeriveDetailViewController)
        -> TabControllerDeriviationFunctionType
    {
        return .masterDetailViewController(
            MasterDetailViewControllerDeriviationFuctionType(
                masterFunctionType: .controller(deriveMasterViewController),
                detailFunctionType: .controllerInNavigationController(deriveDetailViewControllerInNavigationController)
            )
        )
    }
    
    public static func derive(
        deriveMasterViewControllerInNavigationController: @escaping DeriveMasterViewController,
        deriveDetailViewControllerInNavigationController: @escaping DeriveDetailViewController)
        -> TabControllerDeriviationFunctionType
    {
        return .masterDetailViewController(
            MasterDetailViewControllerDeriviationFuctionType(
                masterFunctionType: .controllerInNavigationController(deriveMasterViewControllerInNavigationController),
                detailFunctionType: .controllerInNavigationController(deriveDetailViewControllerInNavigationController)
            )
        )
    }
}
