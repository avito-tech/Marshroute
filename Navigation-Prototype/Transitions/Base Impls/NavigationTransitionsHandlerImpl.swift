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
        // дополняем исходные параметры анимации информацией о своем навигационным контроллере, если нужно
        var fixedLaunchingContext = launchingContext
        fillMissingAnimationSourceParametersFor(animationLaunchingContext: &fixedLaunchingContext)

        // готовим анимационный контекст и запускаем анимации перехода
        switch fixedLaunchingContext.transitionStyle {
        case .Push(let animator):
            let converter = NavigationAnimationLaunchingContextConverterImpl()
            if let animationContext = converter.convertAnimationLaunchingContextToAnimationContext(fixedLaunchingContext) {
                animator.animatePerformingNavigationTransition(animationContext: animationContext)
            }
        
        case .Modal(let animator):
            let converter = NavigationAnimationLaunchingContextConverterImpl()
            if let animationContext = converter.convertAnimationLaunchingContextToAnimationContext(fixedLaunchingContext) {
                animator.animatePerformingNavigationTransition(animationContext: animationContext)
            }
        
        case .PopoverFromButtonItem(_, let animator):
            let converter = PopoverAnimationLaunchingContextConverterImpl()
            if let animationContext = converter.convertAnimationLaunchingContextToAnimationContext(fixedLaunchingContext) {
                animator.animatePerformingPopoverTransition(animationContext: animationContext)
            }

        case .PopoverFromView(_, _, let animator):
            let converter = PopoverAnimationLaunchingContextConverterImpl()
            if let animationContext = converter.convertAnimationLaunchingContextToAnimationContext(fixedLaunchingContext) {
                animator.animatePerformingPopoverTransition(animationContext: animationContext)
            }
        }
    }

    
    func launchAnimationOfUndoingTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext)
    {
        // дополняем исходные параметры анимации информацией о своем навигационным контроллере, если нужно
        var fixedLaunchingContext = launchingContext
        fillMissingAnimationSourceParametersFor(animationLaunchingContext: &fixedLaunchingContext)
        
        // готовим анимационный контекст и запускаем анимации обратного перехода
        switch fixedLaunchingContext.transitionStyle {
        case .Push(let animator):
            let converter = NavigationAnimationLaunchingContextConverterImpl()
            if let animationContext = converter.convertAnimationLaunchingContextToAnimationContext(fixedLaunchingContext) {
                animator.animateUndoingNavigationTransition(animationContext: animationContext)
            }
            
        case .Modal(let animator):
            let converter = NavigationAnimationLaunchingContextConverterImpl()
            if let animationContext = converter.convertAnimationLaunchingContextToAnimationContext(fixedLaunchingContext) {
                animator.animateUndoingNavigationTransition(animationContext: animationContext)
            }
            
        case .PopoverFromButtonItem(_, let animator):
            let converter = PopoverAnimationLaunchingContextConverterImpl()
            if let animationContext = converter.convertAnimationLaunchingContextToAnimationContext(fixedLaunchingContext) {
                animator.animateUndoingPopoverTransition(animationContext: animationContext)
            }
            
        case .PopoverFromView(_, _, let animator):
            let converter = PopoverAnimationLaunchingContextConverterImpl()
            if let animationContext = converter.convertAnimationLaunchingContextToAnimationContext(fixedLaunchingContext) {
                animator.animateUndoingPopoverTransition(animationContext: animationContext)
            }
        }
    }
    
    func launchAnimationOfResettingWithTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext)
    {
        // дополняем исходные параметры анимации информацией о своем навигационным контроллере, если нужно
        var fixedLaunchingContext = launchingContext
        fillMissingAnimationSourceParametersFor(animationLaunchingContext: &fixedLaunchingContext)
        
        // готовим анимационный контекст и запускаем анимации обновления
        switch fixedLaunchingContext.transitionStyle {
        case .Push(let animator):
            let converter = NavigationAnimationLaunchingContextConverterImpl()
            if let animationContext = converter.convertAnimationLaunchingContextToAnimationContext(fixedLaunchingContext) {
                animator.animateResettingWithNavigationTransition(animationContext: animationContext)
            }
            
        case .Modal(let animator):
            let converter = NavigationAnimationLaunchingContextConverterImpl()
            if let animationContext = converter.convertAnimationLaunchingContextToAnimationContext(fixedLaunchingContext) {
                animator.animateResettingWithNavigationTransition(animationContext: animationContext)
            }
            
        case .PopoverFromButtonItem(_, let animator):
            let converter = PopoverAnimationLaunchingContextConverterImpl()
            if let animationContext = converter.convertAnimationLaunchingContextToAnimationContext(fixedLaunchingContext) {
                animator.animateResettingWithPopoverTransition(animationContext: animationContext)
            }
            
        case .PopoverFromView(_, _, let animator):
            let converter = PopoverAnimationLaunchingContextConverterImpl()
            if let animationContext = converter.convertAnimationLaunchingContextToAnimationContext(fixedLaunchingContext) {
                animator.animateResettingWithPopoverTransition(animationContext: animationContext)
            }
        }
    }
}

// MARK: - helpers
private extension NavigationTransitionsHandlerImpl {

    func fillMissingAnimationSourceParametersFor(inout animationLaunchingContext launchingContext: TransitionAnimationLaunchingContext)
    {
        // дополняем исходные параметры анимации информацией о своем навигационным контроллере, если нужно
        switch launchingContext.transitionStyle {
        case .Push(_), .Modal(_):
            guard launchingContext.animationSourceParameters == nil
                else { assert(false, "такой случай не рассмотрен. нужно мерджить чужие и свои параметры анимации"); break }
            
            launchingContext.animationSourceParameters = NavigationAnimationSourceParameters(navigationController: navigationController)
            
        default:
            break
        }
    }
}
