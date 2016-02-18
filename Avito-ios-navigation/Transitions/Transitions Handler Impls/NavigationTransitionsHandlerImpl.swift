import UIKit

final public class NavigationTransitionsHandlerImpl: AnimatingTransitionsHandler {
    private weak var navigationController: UINavigationController?
    
    public init(navigationController: UINavigationController,
        transitionsCoordinator: TransitionsCoordinator)
    {
        self.navigationController = navigationController
        super.init(transitionsCoordinator: transitionsCoordinator)
    }

    // MARK: - TransitionAnimationsLauncher
    override public func launchAnimationOfPerformingTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext)
    {
        guard let navigationController = navigationController
            else { return }
        
        if launchingContext.needsNavigationAnimationSourceParameters {
            let navigationAnimationSourceParameters = NavigationAnimationSourceParameters(navigationController: navigationController)
            launchingContext.launchAnimationOfPerformingTransition(navigationAnimationSourceParameters)
        }
        else {
            launchingContext.launchAnimationOfPerformingTransition()
        }
    }
    
    override public func launchAnimationOfUndoingTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext)
    {
        guard let navigationController = navigationController
            else { return }
        
        if launchingContext.needsNavigationAnimationSourceParameters {
            let navigationAnimationSourceParameters = NavigationAnimationSourceParameters(navigationController: navigationController)
            launchingContext.launchAnimationOfUndoingTransition(navigationAnimationSourceParameters)
        }
        else {
            launchingContext.launchAnimationOfUndoingTransition()
        }
    }
    
    override public func launchAnimationOfResettingWithTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext)
    {
        guard let navigationController = navigationController
            else { return }
        
        if launchingContext.needsNavigationAnimationSourceParameters {
            let navigationAnimationSourceParameters = NavigationAnimationSourceParameters(navigationController: navigationController)
            launchingContext.launchAnimationOfResettingWithTransition(navigationAnimationSourceParameters)
        }
        else {
            launchingContext.launchAnimationOfResettingWithTransition()
        }
    }
}