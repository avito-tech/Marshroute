import UIKit

public struct MarshrouteMasterDetailModule<V: UIViewController> {
    public let viewController: V
    public let masterDetailRouterSeed: MasterDetailRouterSeed
    
    public init(
        viewController: V,
        masterDetailRouterSeed: MasterDetailRouterSeed)
    {
        self.viewController = viewController
        self.masterDetailRouterSeed = masterDetailRouterSeed
    }
}
