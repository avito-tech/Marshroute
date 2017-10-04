public struct MasterDetailViewControllerDeriviationFuctionType {
    public let masterFunctionType: MasterViewControllerDeriviationFunctionType
    public let detailFunctionType: DetailViewControllerDeriviationFunctionType
    
    public init(
        masterFunctionType: MasterViewControllerDeriviationFunctionType,
        detailFunctionType: DetailViewControllerDeriviationFunctionType)
    {
        self.masterFunctionType = masterFunctionType
        self.detailFunctionType = detailFunctionType
    }
}
