/// Базовый класс для анимирующих обработчиков переходов
open class AnimatingTransitionsHandler: TransitionAnimationsLauncher, TransitionsCoordinatorHolder, TransitionsHandler {
    // MARK: - TransitionsCoordinatorHolder
    open let transitionsCoordinator: TransitionsCoordinator
    
    public init(transitionsCoordinator: TransitionsCoordinator)
    {
        self.transitionsCoordinator = transitionsCoordinator
    }
    
    // MARK: - TransitionsHandler
    open func performTransition(context: PresentationTransitionContext)
    {
        transitionsCoordinator.coordinatePerformingTransition(context: context, forAnimatingTransitionsHandler: self)
    }
    
    open func undoTransitionsAfter(transitionId: TransitionId)
    {
        transitionsCoordinator.coordinateUndoingTransitionsAfter(transitionId: transitionId, forAnimatingTransitionsHandler: self)
    }
    
    open func undoTransitionWith(transitionId: TransitionId)
    {
        transitionsCoordinator.coordinateUndoingTransitionWith(transitionId: transitionId, forAnimatingTransitionsHandler: self)
    }
    
    open func undoAllChainedTransitions()
    {
        transitionsCoordinator.coordinateUndoingAllChainedTransitions(forAnimatingTransitionsHandler: self)
    }
    
    open func undoAllTransitions()
    {
        transitionsCoordinator.coordinateUndoingAllTransitions(forAnimatingTransitionsHandler: self)
    }
    
    open func resetWithTransition(context: ResettingTransitionContext)
    {
        transitionsCoordinator.coordinateResettingWithTransition(context: context, forAnimatingTransitionsHandler: self)
    }
    
    // MARK: - TransitionAnimationsLauncher
    open func launchPresentationAnimation(launchingContextBox: inout PresentationAnimationLaunchingContextBox)
    {
        switch launchingContextBox {
        case .modal(let launchingContext):
            let modalPresentationAnimationContext = ModalPresentationAnimationContext(
                modalPresentationAnimationLaunchingContext: launchingContext
            )
            
            if let animationContext = modalPresentationAnimationContext {
                launchingContext.animator.animatePerformingTransition(animationContext: animationContext)
            }
            
        case .modalNavigation(let launchingContext):
            let modalNavigationPresentationAnimationContext = ModalNavigationPresentationAnimationContext(
                modalNavigationPresentationAnimationLaunchingContext: launchingContext
            )
            
            if let animationContext = modalNavigationPresentationAnimationContext {
                launchingContext.animator.animatePerformingTransition(animationContext: animationContext)
            }
            
        case .modalEndpointNavigation(let launchingContext):
            let modalEndpointNavigationPresentationAnimationContext = ModalEndpointNavigationPresentationAnimationContext(
                modalEndpointNavigationPresentationAnimationLaunchingContext: launchingContext
            )
            
            if let animationContext = modalEndpointNavigationPresentationAnimationContext {
                launchingContext.animator.animatePerformingTransition(animationContext: animationContext)
            }
            
        case .modalMasterDetail(let launchingContext):
            let modalMasterDetailPresentationAnimationContext = ModalMasterDetailPresentationAnimationContext(
                modalMasterDetailPresentationAnimationLaunchingContext: launchingContext
            )
            
            if let animationContext = modalMasterDetailPresentationAnimationContext {
                launchingContext.animator.animatePerformingTransition(animationContext: animationContext)
            }
            
        case .push:
            debugPrint("you were supposed to create `NavigationTransitionsHandlerImpl`"); return
            
        case .popover(let launchingContext):
            let popoverPresentationAnimationContext = PopoverPresentationAnimationContext(
                popoverPresentationAnimationLaunchingContext: launchingContext
            )
            
            if let animationContext = popoverPresentationAnimationContext {
                launchingContext.animator.animatePerformingTransition(animationContext: animationContext)
            }
            
        case .popoverNavigation(let launchingContext):
            let popoverNavigationPresentationAnimationContext = PopoverNavigationPresentationAnimationContext(
                popoverNavigationPresentationAnimationLaunchingContext: launchingContext
            )
            
            if let animationContext = popoverNavigationPresentationAnimationContext {
                launchingContext.animator.animatePerformingTransition(animationContext: animationContext)
            }
        }
    }
    
    open func launchDismissalAnimation(launchingContextBox: DismissalAnimationLaunchingContextBox)
    {
        switch launchingContextBox {
        case .modal(let launchingContext):
            let modalDismissalAnimationContext = ModalDismissalAnimationContext(
                modalDismissalAnimationLaunchingContext: launchingContext
            )
            
            launchingContext.animator.animateUndoingTransition(animationContext: modalDismissalAnimationContext)
            
        case .modalNavigation(let launchingContext):
            let modalNavigationDismissalAnimationContext = ModalNavigationDismissalAnimationContext(
                modalNavigationDismissalAnimationLaunchingContext: launchingContext
            )
            
            launchingContext.animator.animateUndoingTransition(animationContext: modalNavigationDismissalAnimationContext)
            
        case .modalEndpointNavigation(let launchingContext):
            let modalEndpointNavigationDismissalAnimationContext = ModalEndpointNavigationDismissalAnimationContext(
                modalEndpointNavigationDismissalAnimationLaunchingContext: launchingContext
            )
            
            launchingContext.animator.animateUndoingTransition(animationContext: modalEndpointNavigationDismissalAnimationContext)
            
        case .modalMasterDetail(let launchingContext):
            let modalMasterDetailDismissalAnimationContext = ModalMasterDetailDismissalAnimationContext(
                modalMasterDetailDismissalAnimationLaunchingContext: launchingContext
            )
            
            launchingContext.animator.animateUndoingTransition(animationContext: modalMasterDetailDismissalAnimationContext)
            
        case .pop(let launchingContext):
            let popAnimationContext = PopAnimationContext(
                popAnimationLaunchingContext: launchingContext
            )
            
            launchingContext.animator.animateUndoingTransition(animationContext: popAnimationContext)
            
        case .popover(let launchingContext):
            let popoverDismissalAnimationContext = PopoverDismissalAnimationContext(
                popoverDismissalAnimationLaunchingContext: launchingContext
            )
            
            launchingContext.animator.animateUndoingTransition(animationContext: popoverDismissalAnimationContext)
            
        case .popoverNavigation(let launchingContext):
            let popoverNavigationDismissalAnimationContext = PopoverNavigationDismissalAnimationContext(
                popoverNavigationDismissalAnimationLaunchingContext: launchingContext
            )
            
            launchingContext.animator.animateUndoingTransition(animationContext: popoverNavigationDismissalAnimationContext)
        }
    }
    
    open func launchResettingAnimation(launchingContextBox: inout ResettingAnimationLaunchingContextBox)
    {
        switch launchingContextBox {
        case .settingNavigationRoot(let launchingContext):
            let settingAnimationContext = SettingNavigationAnimationContext(
                settingAnimationLaunchingContext: launchingContext
            )
            
            if let animationContext = settingAnimationContext {
                launchingContext.animator.animateResettingWithTransition(animationContext: animationContext)
            }
            
        case .resettingNavigationRoot:
            debugPrint("you were supposed to create `NavigationTransitionsHandlerImpl`"); return
            
        case .registering:
            break; // no need for animations
            
        case .registeringEndpointNavigation:
            break // no need for animations
        }
    }
}
