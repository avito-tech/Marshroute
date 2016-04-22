/// Базовый класс для анимирующих обработчиков переходов
public class AnimatingTransitionsHandler: TransitionAnimationsLauncher, TransitionsCoordinatorHolder, TransitionsHandler {
    // MARK: - TransitionsCoordinatorHolder
    public let transitionsCoordinator: TransitionsCoordinator
    
    public init(transitionsCoordinator: TransitionsCoordinator)
    {
        self.transitionsCoordinator = transitionsCoordinator
    }
    
    // MARK: - TransitionsHandler
    public func performTransition(context context: PresentationTransitionContext)
    {
        transitionsCoordinator.coordinatePerformingTransition(context: context, forAnimatingTransitionsHandler: self)
    }
    
    public func undoTransitionsAfter(transitionId transitionId: TransitionId)
    {
        transitionsCoordinator.coordinateUndoingTransitionsAfter(transitionId: transitionId, forAnimatingTransitionsHandler: self)
    }
    
    public func undoTransitionWith(transitionId transitionId: TransitionId)
    {
        transitionsCoordinator.coordinateUndoingTransitionWith(transitionId: transitionId, forAnimatingTransitionsHandler: self)
    }
    
    public func undoAllChainedTransitions()
    {
        transitionsCoordinator.coordinateUndoingAllChainedTransitions(forAnimatingTransitionsHandler: self)
    }
    
    public func undoAllTransitions()
    {
        transitionsCoordinator.coordinateUndoingAllTransitions(forAnimatingTransitionsHandler: self)
    }
    
    public func resetWithTransition(context context: ResettingTransitionContext)
    {
        transitionsCoordinator.coordinateResettingWithTransition(context: context, forAnimatingTransitionsHandler: self)
    }
    
    // MARK: - TransitionAnimationsLauncher
    public func launchPresentationAnimation(launchingContextBox launchingContextBox: PresentationAnimationLaunchingContextBox)
    {
        switch launchingContextBox {
        case .Modal(let launchingContext):
            let modalPresentationAnimationContext = ModalPresentationAnimationContext(
                modalPresentationAnimationLaunchingContext: launchingContext
            )
            
            if let animationContext = modalPresentationAnimationContext {
                launchingContext.animator.animatePerformingTransition(animationContext: animationContext)
            }
            
        case .ModalNavigation(let launchingContext):
            let modalNavigationPresentationAnimationContext = ModalNavigationPresentationAnimationContext(
                modalNavigationPresentationAnimationLaunchingContext: launchingContext
            )
            
            if let animationContext = modalNavigationPresentationAnimationContext {
                launchingContext.animator.animatePerformingTransition(animationContext: animationContext)
            }
            
        case .ModalEndpointNavigation(let launchingContext):
            let modalEndpointNavigationPresentationAnimationContext = ModalEndpointNavigationPresentationAnimationContext(
                modalEndpointNavigationPresentationAnimationLaunchingContext: launchingContext
            )
            
            if let animationContext = modalEndpointNavigationPresentationAnimationContext {
                launchingContext.animator.animatePerformingTransition(animationContext: animationContext)
            }
            
        case .Push(_):
            assert(false, "you were supposed to create `NavigationTransitionsHandlerImpl`"); return
            
        case .Popover(let launchingContext):
            let popoverPresentationAnimationContext = PopoverPresentationAnimationContext(
                popoverPresentationAnimationLaunchingContext: launchingContext
            )
            
            if let animationContext = popoverPresentationAnimationContext {
                launchingContext.animator.animatePerformingTransition(animationContext: animationContext)
            }
            
        case .PopoverNavigation(let launchingContext):
            let popoverNavigationPresentationAnimationContext = PopoverNavigationPresentationAnimationContext(
                popoverNavigationPresentationAnimationLaunchingContext: launchingContext
            )
            
            if let animationContext = popoverNavigationPresentationAnimationContext {
                launchingContext.animator.animatePerformingTransition(animationContext: animationContext)
            }
        }
    }
    
    public func launchDismissalAnimation(launchingContextBox launchingContextBox: DismissalAnimationLaunchingContextBox)
    {
        switch launchingContextBox {
        case .Modal(let launchingContext):
            let modalDismissalAnimationContext = ModalDismissalAnimationContext(
                modalDismissalAnimationLaunchingContext: launchingContext
            )
            
            launchingContext.animator.animateUndoingTransition(animationContext: modalDismissalAnimationContext)
            
        case .ModalNavigation(let launchingContext):
            let modalNavigationDismissalAnimationContext = ModalNavigationDismissalAnimationContext(
                modalNavigationDismissalAnimationLaunchingContext: launchingContext
            )
            
            launchingContext.animator.animateUndoingTransition(animationContext: modalNavigationDismissalAnimationContext)
            
        case .ModalEndpointNavigation(let launchingContext):
            let modalEndpointNavigationDismissalAnimationContext = ModalEndpointNavigationDismissalAnimationContext(
                modalEndpointNavigationDismissalAnimationLaunchingContext: launchingContext
            )
            
            launchingContext.animator.animateUndoingTransition(animationContext: modalEndpointNavigationDismissalAnimationContext)
            
            
        case .Pop(let launchingContext):
            let popAnimationContext = PopAnimationContext(
                popAnimationLaunchingContext: launchingContext
            )
            
            launchingContext.animator.animateUndoingTransition(animationContext: popAnimationContext)
            
        case .Popover(let launchingContext):
            let popoverDismissalAnimationContext = PopoverDismissalAnimationContext(
                popoverDismissalAnimationLaunchingContext: launchingContext
            )
            
            launchingContext.animator.animateUndoingTransition(animationContext: popoverDismissalAnimationContext)
            
        case .PopoverNavigation(let launchingContext):
            let popoverNavigationDismissalAnimationContext = PopoverNavigationDismissalAnimationContext(
                popoverNavigationDismissalAnimationLaunchingContext: launchingContext
            )
            
            launchingContext.animator.animateUndoingTransition(animationContext: popoverNavigationDismissalAnimationContext)
        }
    }
    
    public func launchResettingAnimation(launchingContextBox launchingContextBox: ResettingAnimationLaunchingContextBox)
    {
        switch launchingContextBox {
        case .SetNavigation(let launchingContext):
            let settingAnimationContext = SettingNavigationAnimationContext(
                settingAnimationLaunchingContext: launchingContext
            )
            
            if let animationContext = settingAnimationContext {
                launchingContext.animator.animateResettingWithTransition(animationContext: animationContext)
            }
            
        case .ResetNavigation(_):
            assert(false, "you were supposed to create `NavigationTransitionsHandlerImpl`"); return
            
        case .Reset:
            break; // no need for animations
        }
    }
}