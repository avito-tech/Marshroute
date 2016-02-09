import UIKit

final class NavigationTransitionsHandlerImpl {
    
    private weak var navigationController: UINavigationController?
    private let transitionsCoordinatorPrivate: TransitionsCoordinator
    
    init(navigationController: UINavigationController,
        transitionsCoordinator: TransitionsCoordinator)
    {
        self.navigationController = navigationController
        self.transitionsCoordinatorPrivate = transitionsCoordinator
    }
}

// MARK: - TransitionsHandler
extension NavigationTransitionsHandlerImpl: TransitionsHandler {}

// MARK: - TransitionsCoordinatorStorer
extension NavigationTransitionsHandlerImpl: TransitionsCoordinatorStorer {
    var transitionsCoordinator: TransitionsCoordinator {
        return transitionsCoordinatorPrivate
    }
}

// MARK: - TransitionsAnimatorClient
extension NavigationTransitionsHandlerImpl: TransitionsAnimatorClient {
    func launchAnimationOfPerformingTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext)
    {
        // готовим анимационный контекст и запускаем анимации перехода
        if let animationContext = createAnimationContextFor(animationLaunchingContext: launchingContext) {
            launchingContext.animator.animatePerformingTransition(animationContext: animationContext)
        }
    }
    
    func launchAnimationOfUndoingTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext)
    {
        // готовим анимационный контекст и запускаем анимации обратного перехода
        if let animationContext = createAnimationContextFor(animationLaunchingContext: launchingContext) {
            launchingContext.animator.animateUndoingTransition(animationContext: animationContext)
        }
    }
    
    func launchAnimationOfResettingWithTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext)
    {
        // готовим анимационный контекст и запускаем анимации обновления
        if let animationContext = createAnimationContextFor(animationLaunchingContext: launchingContext) {
            launchingContext.animator.animateResettingWithTransition(animationContext: animationContext)
        }
    }
}

// MARK: - helpers
private extension NavigationTransitionsHandlerImpl {
    func createAnimationContextFor(var animationLaunchingContext launchingContext: TransitionAnimationLaunchingContext)
        -> TransitionAnimationContext?
    {
        var result: TransitionAnimationContext?
        
        // дополняем исходные параметры анимации информацией о своем навигационным контроллере, если нужно
        switch launchingContext.transitionStyle {
        case .Push, .Modal:
            guard launchingContext.animationSourceParameters == nil
                else { assert(false, "такой случай не рассмотрен. нужно мерджить чужие и свои параметры анимации"); break }
            
            launchingContext.animationSourceParameters = NavigationAnimationSourceParameters(navigationController: navigationController)
            let converter = NavigationAnimationLaunchingContextConverterImpl()
            result = converter.convertAnimationLaunchingContextToAnimationContext(launchingContext)

        case .PopoverFromButtonItem(_), .PopoverFromView(_, _):
            let converter = PopoverAnimationLaunchingContextConverterImpl()
            result = converter.convertAnimationLaunchingContextToAnimationContext(launchingContext)
        }
        
        return result
    }
}
