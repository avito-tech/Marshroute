import UIKit

public struct MarshrouteModule<ViewController: UIViewController> {
    public let viewController: ViewController
    public let routerSeed: RouterSeed
    
    public init(
        viewController: ViewController,
        routerSeed: RouterSeed)
    {
        self.viewController = viewController
        self.routerSeed = routerSeed
    }
}
