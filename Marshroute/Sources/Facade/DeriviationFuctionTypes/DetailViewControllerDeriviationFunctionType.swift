public typealias DeriveDetailViewController = ((RouterSeed) -> (UIViewController))

/// Defines a type of function to create a simple `UIViewController` (probably wrapped into `UINavigationController`)
public enum DetailViewControllerDeriviationFunctionType {
    /// Creates a `UIViewController`
    case controller(DeriveDetailViewController)

    /// Creates a `UIViewController` wrapped into `UINavigationController`
    case controllerInNavigationController(DeriveDetailViewController)
}
