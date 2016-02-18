import UIKit

public struct NavigationAnimationSourceParameters {
    public private (set) weak var navigationController: UINavigationController?
    
    public init(navigationController: UINavigationController)
    {
        self.navigationController = navigationController
    }
}