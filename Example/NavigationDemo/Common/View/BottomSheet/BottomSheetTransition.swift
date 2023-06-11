import UIKit

final class BottomSheetTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    // MARK: - Properties -
    private let presentAnimator: BottomSheetTransitionPresentAnimator
    private let dismissAnimator: BottomSheetTransitionDismissAnimator
    private let dismissInteractionController: BottomSheetDismissTransitionInteractionController
    private let configuration: BottomSheetTransitionConfiguration
    
    // MARK: - Init -
    init(
        withConfiguration configuration: BottomSheetTransitionConfiguration = BottomSheetTransitionConfiguration())
    {
        presentAnimator = BottomSheetTransitionPresentAnimator()
        dismissAnimator = BottomSheetTransitionDismissAnimator()
        
        dismissInteractionController = BottomSheetDismissTransitionInteractionController(
            bottomSheetTransitionDismissAnimator: dismissAnimator
        )
        
        self.configuration = configuration
        
        super.init()
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return presentAnimator
    }
    
    func animationController(
        forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return dismissAnimator
    }
    
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController) -> UIPresentationController?
    {
        let bottomSheetHeightProvider: BottomSheetHeightProvider =
                 (presented as? BottomSheetHeightProvider)
                 ?? ((presented as? UINavigationController)?.topViewController as? BottomSheetHeightProvider)
                 ?? DefaultBottomSheetHeightProvider()
        
        let bottomSheetDimmingViewProvider: BottomSheetDimmingViewProvider =
                (presented as? BottomSheetDimmingViewProvider)
                ?? ((presented as? UINavigationController)?.topViewController as? BottomSheetDimmingViewProvider)
                ?? DefaultBottomSheetDimmingViewProvider()
        
        let bottomSheetPresentableLifecycle =
                (presented as? BottomSheetPresentableLifecycle)
                ?? ((presented as? UINavigationController)?.topViewController as? BottomSheetPresentableLifecycle)
        
        let bottomSheetScrollProvider =
            (presented as? BottomSheetScrollProvider)
            ?? ((presented as? UINavigationController)?.topViewController as? BottomSheetScrollProvider)
            ?? DefaultBottomSheetScrollProvider()
        
        return BottomSheetTransitionPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            configuration: configuration,
            dismissTransitionController: dismissInteractionController,
            bottomSheetHeightProvider: bottomSheetHeightProvider,
            bottomSheetScrollProvider: bottomSheetScrollProvider,
            bottomSheetDimmingViewProvider: bottomSheetDimmingViewProvider,
            bottomSheetPresentableLifecycle: bottomSheetPresentableLifecycle
        )
    }
    
    func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
    {
        return dismissInteractionController.isTransitionInProgress ? dismissInteractionController : nil
    }
}
