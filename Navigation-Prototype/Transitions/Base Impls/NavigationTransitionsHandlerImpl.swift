import UIKit

final class NavigationTransitionsHandlerImpl {
    private weak var navigationController: UINavigationController?
    
    let transitionsCoordinator: TransitionsCoordinator
    
    init(navigationController: UINavigationController,
        transitionsCoordinator: TransitionsCoordinator)
    {
        self.navigationController = navigationController
        self.transitionsCoordinator = transitionsCoordinator
    }
}

// MARK: - TransitionsHandler
extension NavigationTransitionsHandlerImpl: TransitionsHandler {}

// MARK: - TransitionsCoordinatorStorer
extension NavigationTransitionsHandlerImpl: TransitionsCoordinatorStorer {}

// MARK: - TransitionAnimationsLauncher
extension NavigationTransitionsHandlerImpl: TransitionAnimationsLauncher {
    func launchAnimationOfPerformingTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext)
    {
        if launchingContext.needsNavigationAnimationSourceParameters {
            let navigationAnimationSourceParameters = NavigationAnimationSourceParameters(navigationController: navigationController)
            launchingContext.launchAnimationOfPerformingTransition(navigationAnimationSourceParameters)
        }
        else {
            launchingContext.launchAnimationOfPerformingTransition()
        }
    }
    
    func launchAnimationOfUndoingTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext)
    {
        if launchingContext.needsNavigationAnimationSourceParameters {
            let navigationAnimationSourceParameters = NavigationAnimationSourceParameters(navigationController: navigationController)
            launchingContext.launchAnimationOfUndoingTransition(navigationAnimationSourceParameters)
        }
        else {
            launchingContext.launchAnimationOfUndoingTransition()
        }
    }
    
    func launchAnimationOfResettingWithTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext)
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