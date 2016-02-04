import UIKit

final class NavigationTransitionsHandler {
    
    private unowned let navigationController: UINavigationController
    private let transitionsCoordinatorPrivate: TransitionsCoordinator
    private let launchingContextConverter: TransitionAnimationLaunchingContextConverter
    
    init(navigationController: UINavigationController,
        transitionsCoordinator: TransitionsCoordinator,
        animationLaunchingContextConverter: TransitionAnimationLaunchingContextConverter = TransitionAnimationLaunchingContextConverterImpl())
    {
        self.navigationController = navigationController
        self.transitionsCoordinatorPrivate = transitionsCoordinator
        self.launchingContextConverter = animationLaunchingContextConverter
    }
}

// MARK: - TransitionsHandler
extension NavigationTransitionsHandler: TransitionsHandler {}

// MARK: - TransitionsCoordinatorStorer
extension NavigationTransitionsHandler: TransitionsCoordinatorStorer {
    var transitionsCoordinator: TransitionsCoordinator {
        return transitionsCoordinatorPrivate
    }
}

// MARK: - TransitionsAnimatorClient
extension NavigationTransitionsHandler: TransitionsAnimatorClient {
    func launchAnimatingOfPerformingTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext)
    {
        // готовим анимационный контекст и запускаем анимации перехода
        if let animationContext = createAnimationContextFor(animationLaunchingContext: launchingContext) {
            launchingContext.animator.animatePerformingTransition(animationContext: animationContext)
        }
    }
    
    func launchAnimatingOfUndoingTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext)
    {
        // готовим анимационный контекст и запускаем анимации обратного перехода
        if let animationContext = createAnimationContextFor(animationLaunchingContext: launchingContext) {
            launchingContext.animator.animateUndoingTransition(animationContext: animationContext)
        }
    }
    
    func launchAnimatingOfResettingWithTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext)
    {
        // готовим анимационный контекст и запускаем анимации обновления
        if let animationContext = createAnimationContextFor(animationLaunchingContext: launchingContext) {
            launchingContext.animator.animateResettingWithTransition(animationContext: animationContext)
        }
    }
}

// MARK: - helpers
private extension NavigationTransitionsHandler {
    func createAnimationContextFor(var animationLaunchingContext launchingContext: TransitionAnimationLaunchingContext)
        -> TransitionAnimationContext?
    {
        // дополняем исходные параметры анимации информацией о своем навигационным контроллере, если нужно
        switch launchingContext.transitionStyle {
        case .Push, .Modal:
            guard launchingContext.animationSourceParameters == nil else {
                assert(false, "такой случай не рассмотрен. нужно мерджить чужие и свои параметры анимации")
                break
            }
            launchingContext.animationSourceParameters = NavigationAnimationSourceParameters(navigationController: navigationController)
        default:
            break
        }
        
        // создаем анимационный контекст
        let result = launchingContextConverter.convertAnimationLaunchingContextToAnimationContext(launchingContext)
        return result
    }
}