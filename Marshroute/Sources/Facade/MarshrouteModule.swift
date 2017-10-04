import UIKit

public struct MarshrouteModule<V: UIViewController> {
    public let viewController: V
    public let routerSeed: RouterSeed
    
    public init(
        viewController: V,
        routerSeed: RouterSeed)
    {
        self.viewController = viewController
        self.routerSeed = routerSeed
    }
}
