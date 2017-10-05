public typealias DeriveMasterDetailViewController = ((RouterSeed) -> (UISplitViewController))

public struct MasterDetailViewControllerDeriviationFuctionType {
    public let deriveMasterDetailViewController: DeriveMasterDetailViewController?
    public let masterFunctionType: MasterViewControllerDeriviationFunctionType
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
