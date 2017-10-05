public typealias DeriveMasterDetailViewController = ((RouterSeed) -> (UISplitViewController))

/// Defines set of functions to create a master-detail view controller (`UISplitViewController`)
public struct MasterDetailViewControllerDeriviationFuctionType {
    /// Creates master-detail view controller (`UISplitViewController`)
    public let deriveMasterDetailViewController: DeriveMasterDetailViewController?
    
    /// Creates master view controller (probably wrapped into `UINavigationController`)
    public let masterFunctionType: MasterViewControllerDeriviationFunctionType
    
    /// Creates detail view controller (probably wrapped into `UINavigationController`) 
    public let detailFunctionType: DetailViewControllerDeriviationFunctionType
    
    public init(
        deriveMasterDetailViewController: DeriveMasterDetailViewController?,
        masterFunctionType: MasterViewControllerDeriviationFunctionType,
        detailFunctionType: DetailViewControllerDeriviationFunctionType)
    {
        self.deriveMasterDetailViewController = deriveMasterDetailViewController
        self.masterFunctionType = masterFunctionType
        self.detailFunctionType = detailFunctionType
    }
}
