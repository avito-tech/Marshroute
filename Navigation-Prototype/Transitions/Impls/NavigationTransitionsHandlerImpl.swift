import UIKit

final class NavigationTransitionsHandlerImpl: AnimatingTransitionsHandler {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController,
        transitionsCoordinator: TransitionsCoordinator)
    {
        self.navigationController = navigationController
        super.init(transitionsCoordinator: transitionsCoordinator)
    }

    // MARK: - TransitionAnimationsLauncher
    override func launchAnimationOfPerformingTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext)
    {
        if launchingContext.needsNavigationAnimationSourceParameters {
            let navigationAnimationSourceParameters = NavigationAnimationSourceParameters(navigationController: navigationController)
            launchingContext.launchAnimationOfPerformingTransition(navigationAnimationSourceParameters)
        }
        else {
            launchingContext.launchAnimationOfPerformingTransition()
        }
    }
    
    override func launchAnimationOfUndoingTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext)
    {
        if launchingContext.needsNavigationAnimationSourceParameters {
            let navigationAnimationSourceParameters = NavigationAnimationSourceParameters(navigationController: navigationController)
            launchingContext.launchAnimationOfUndoingTransition(navigationAnimationSourceParameters)
        }
        else {
            launchingContext.launchAnimationOfUndoingTransition()
        }
    }
    
    override func launchAnimationOfResettingWithTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext)
    {
        if launchingContext.needsNavigationAnimationSourceParameters {
            let navigationAnimationSourceParameters = NavigationAnimationSourceParameters(navigationController: navigationController)
            launchingContext.launchAnimationOfResettingWithTransition(navigationAnimationSourceParameters)
        }
        else {
            launchingContext.launchAnimationOfResettingWithTransition()
        }
    }
}