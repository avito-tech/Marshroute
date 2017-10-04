public typealias DeriveDetailViewController = ((RouterSeed) -> (UIViewController))

public enum DetailViewControllerDeriviationFunctionType {
    // Creates a `UIViewController`
    case controller(DeriveDetailViewController)

    // Creates a `UIViewController` wrapped in `UINavigationController`
    case controllerInNavigationController(DeriveDetailViewController)
}
