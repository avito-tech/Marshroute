import UIKit
import Foundation

enum BottomSheetViewState {
    case bottomSheet
    case fullScreen
}

private struct BottomSheetSpec {
    static let velocityThreshold: CGFloat = 2500
    static let expandThreshold: CGFloat = 0.3
    static let collapseThreshold: CGFloat = 0.7
    static let defaultHeight: CGFloat = UIScreen.main.bounds.size.height * 0.5
    static let stateAnimationDuration: TimeInterval = 0.3
    static let stateAnimationUsingSpringWithDamping: CGFloat = 1
    static let stateAnimationInitialSpringVelocity: CGFloat = 0.5
    static let completeTransitionProgressPercentage: CGFloat = 0.4
    static let completeTransitionProgressDelta: CGFloat = 100
}

private class PanData {
    let presentedView: UIView
    let containerView: UIView
    let translation: CGPoint
    let velocity: CGPoint
    
    init(
        presentedView: UIView,
        containerView: UIView,
        gestureRecognizer: UIPanGestureRecognizer)
    {
        self.presentedView = presentedView
        self.containerView = containerView
        self.translation = gestureRecognizer.translation(in: gestureRecognizer.view?.superview)
        self.velocity = gestureRecognizer.velocity(in: gestureRecognizer.view?.superview)
    }
}

private class CachingBottomSheetHeightProvider: BottomSheetHeightProvider {
    
    private let heightProvider: BottomSheetHeightProvider
    private var cache = [CGSize: CGFloat]()
    
    init(heightProvider: BottomSheetHeightProvider) {
        self.heightProvider = heightProvider
    }
    
    func bottomSheetHeight(forContainerSize containerSize: CGSize) -> CGFloat {
        
        if let result = cache[containerSize] {
            return result
        }
        
        let result = heightProvider.bottomSheetHeight(forContainerSize: containerSize)
        cache[containerSize] = result
        return result
    }
    
    func cacheHeight(forContainerSize size: CGSize) {
        _ = bottomSheetHeight(forContainerSize: size)
    }
}

// http://www.openradar.me/21753811
private var allBottomSheetTransitionPresentationControllers = [WeakBox<BottomSheetTransitionPresentationController>]()

final class BottomSheetTransitionPresentationController:
    UIPresentationController,
    UIGestureRecognizerDelegate
{
    // MARK: - Properties -
    private let dismissTransitionController: BottomSheetDismissTransitionInteractionController
    private let bottomSheetHeightProvider: BottomSheetHeightProvider
    private let bottomSheetScrollProvider: BottomSheetScrollProvider
    private let bottomSheetDimmingViewProvider: BottomSheetDimmingViewProvider
    private let configuration: BottomSheetTransitionConfiguration
    private let bottomSheetPresentableLifecycle: BottomSheetPresentableLifecycle?
    private var keyboardFrame: CGRect?
    
    private var keyboardOffset: CGFloat {
        guard let keyboardFrame = keyboardFrame else { return 0 }
        guard let containerView = containerView else { return 0 }
        
        return max(0, containerView.bounds.size.height - keyboardFrame.origin.y)
    }
    
    private(set) var bottomSheetViewState: BottomSheetViewState
    
    private var dimmingView: UIView? {
        
        didSet {
            guard dimmingView !== oldValue else { return }
            oldValue?.removeFromSuperview()
        }
    }
    
    private(set) var isPanInProgress = false
    private var panCachingBottomSheetHeightProvider: CachingBottomSheetHeightProvider?
    
    private var activeScrollView: UIScrollView?
    private var scrollViewKVOs: [KeyValueObserver] = []
    
    private var smoothingTranslationY: CGFloat = 0
    private var isPanBeganWithScrollView = false
    
    // MARK: - UIPresentationController -
    init(
        presentedViewController: UIViewController,
        presenting presentingViewController: UIViewController?,
        configuration: BottomSheetTransitionConfiguration,
        dismissTransitionController: BottomSheetDismissTransitionInteractionController,
        bottomSheetHeightProvider: BottomSheetHeightProvider,
        bottomSheetScrollProvider: BottomSheetScrollProvider,
        bottomSheetDimmingViewProvider: BottomSheetDimmingViewProvider,
        bottomSheetPresentableLifecycle: BottomSheetPresentableLifecycle?)
    {
        self.configuration = configuration
        self.bottomSheetViewState = configuration.initialState
        self.dismissTransitionController = dismissTransitionController
        self.bottomSheetHeightProvider = bottomSheetHeightProvider
        self.bottomSheetScrollProvider = bottomSheetScrollProvider
        self.bottomSheetDimmingViewProvider = bottomSheetDimmingViewProvider
        self.bottomSheetPresentableLifecycle = bottomSheetPresentableLifecycle
        
        super.init(
            presentedViewController: presentedViewController,
            presenting: presentingViewController
        )
        
        let panGestureRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(onPresentedViewControllerPan(sender:))
        )
        
        panGestureRecognizer.delegate = self
        
        presentedViewController.view.addGestureRecognizer(panGestureRecognizer)

        if configuration.shouldFollowKeyboard {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(onKeyboardWillChangeFrame(_:)),
                name: UIResponder.keyboardWillChangeFrameNotification,
                object: nil
            )
        }
        
        allBottomSheetTransitionPresentationControllers.append(WeakBox(self))
        
        setScrollViewKVOObserver()
    }
    
    deinit {
        for scrollViewKVO in scrollViewKVOs {
            scrollViewKVO.removeAllObservers()
            scrollViewKVO.object = nil
        }

        NotificationCenter.default.removeObserver(self)
        allBottomSheetTransitionPresentationControllers = allBottomSheetTransitionPresentationControllers.compactMap { $0 }
    }
    
    static func presentationController(
        forController controller: UIViewController?) -> BottomSheetTransitionPresentationController?
    {
        return allBottomSheetTransitionPresentationControllers.first {
            $0.value?.presentedViewController === controller || $0.value?.presentingViewController === controller
        }?.value
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        guard let coordinator = presentingViewController.transitionCoordinator else { return }
        
        let dimmingView = makeDimmingView()
        self.dimmingView = dimmingView
        
        dimmingView.alpha = 0
        containerView.addSubview(dimmingView)
        containerView.addSubview(presentedViewController.view)
        
        let frame = getPresentedViewFrame()
        dimmingView.frame = containerView.bounds
        presentedView?.frame = frame.byChangingTop(containerView.bounds.height)
        
        coordinator.animate(
            alongsideTransition: { [weak self] _ in
                
                self?.presentedView?.frame = frame
                dimmingView.alpha = 1
            },
            completion: { [weak self, bottomSheetViewState] _ in
                self?.bottomSheetPresentableLifecycle?.bottomSheetDidChangeViewState(state: bottomSheetViewState)
            }
        )
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentingViewController.transitionCoordinator else { return }
        coordinator.animate(
            alongsideTransition: { [weak self] _ in
                
                self?.dimmingView?.alpha = 0
                self?.presentedView?.frame.origin.y = (self?.containerView?.bounds.size.height ?? 0) - (self?.keyboardOffset ?? 0)
            },
            completion: nil
        )
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {

        if completed {
            dimmingView = nil
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return getPresentedViewFrame()
    }
    
    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator)
    {
        coordinator.animate(
            alongsideTransition: { [weak self] _ in
                self?.presentedView?.frame = self?.getPresentedViewFrame(toSize: size) ?? CGRect.zero
                self?.dimmingView?.frame = self?.containerView?.bounds ?? CGRect.zero
            },
            completion: nil
        )
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer)
        -> Bool
    {
        // disable horizontal and vertical scrolling simultaneously
        if let otherPanGestureRecognizer = otherGestureRecognizer as? UIPanGestureRecognizer,
           bottomSheetViewState == .bottomSheet {
            let translation = otherPanGestureRecognizer.translation(in: nil)
            if abs(translation.x) >= abs(translation.y) {
                return false
            }
        }
        return !bottomSheetScrollProvider.bottomSheetScrollViews().isEmpty
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let scrollViews = bottomSheetScrollProvider.bottomSheetScrollViews()
        let otherScrollView = otherGestureRecognizer.view as? UIScrollView
        let scrollViewsContainsOtherScrollView = otherScrollView.flatMap { scrollViews.contains($0) } != nil

        return !scrollViewsContainsOtherScrollView
            && otherGestureRecognizer is UIPanGestureRecognizer
    }
    
    // MARK: - Helpers -
    private func makeDimmingView() -> UIView {
        
        let view = bottomSheetDimmingViewProvider.dimmingView(frame: containerView?.bounds ?? .zero, style: configuration.dimmingStyle)
        
        if configuration.isCancelable {
            view.addGestureRecognizer(
                UITapGestureRecognizer(
                    target: self,
                    action: #selector(onDimmingViewTap(sender:))
                )
            )
        }

        return view
    }
    
    private func getPresentedViewFrame(
        toSize size: CGSize? = nil,
        bottomSheetHeightProvider: BottomSheetHeightProvider? = nil) -> CGRect
    {
        guard let containerView = containerView else { return CGRect.zero }
        
        let heightProvider = bottomSheetHeightProvider ?? self.bottomSheetHeightProvider
        
        switch bottomSheetViewState {
            
        case .bottomSheet:
            
            let bottomSheetHeight = heightProvider.bottomSheetHeight(forContainerSize: size ?? containerView.frame.size)
            let maximumHeight = min(containerView.bounds.size.height - getTopOffset(), UIScreen.main.bounds.height)
            let height = min(bottomSheetHeight, maximumHeight)
            
            return CGRect(
                x: 0,
                y: max(containerView.bounds.size.height - height - keyboardOffset, getTopOffset()),
                width: containerView.bounds.size.width,
                height: height)
        case .fullScreen:
            return CGRect(
                x: 0,
                y: getTopOffset(),
                width: containerView.bounds.size.width,
                height: containerView.bounds.size.height - getTopOffset()
            )
        }
    }
    
    func setBottomSheetViewState(state: BottomSheetViewState, animated: Bool) {
        
        if configuration.allowStateChange {
            bottomSheetViewState = state
        }
        
        // Если вьюху резко дёргать, она не успевает обновить лейаут до анимации.
        // Тогда анимация происходит криво.
        presentedView?.layoutIfNeeded()
        
        let targetFrame = getPresentedViewFrame()
        
        if let presentedView = presentedView {
            let newHeight = targetFrame.height
            let actualHeight = presentedView.frame.size.height

            if actualHeight < newHeight {
                presentedView.frame.size.height = newHeight
                presentedView.layoutIfNeeded()
            }
        }
        
        UIView.animate(
            withDuration: animated ? BottomSheetSpec.stateAnimationDuration : 0,
            delay: 0,
            options: [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState, .layoutSubviews, .allowAnimatedContent],
            animations: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.dimmingView?.alpha = 1
                strongSelf.presentedView?.frame = targetFrame
            },
            completion: { [weak self] _ in
                self?.bottomSheetPresentableLifecycle?.bottomSheetDidChangeViewState(state: state)
            }
        )
    }
    
    func setAllowStateChange(_ allow: Bool) {
        configuration.allowStateChange = allow
    }
    
    var onManualDismiss: (() -> ())? {
        get { configuration.onManualDismiss }
        set { configuration.onManualDismiss = newValue }
    }
    
    // MARK: - Transition Helpers
    private func shouldCompleteTransition(forProgress progress: CGFloat, panData: PanData) -> Bool {
        let dismissCodition = progress >= BottomSheetSpec.completeTransitionProgressPercentage ||
               panData.velocity.y >= BottomSheetSpec.velocityThreshold ||
               panData.translation.y >= BottomSheetSpec.completeTransitionProgressDelta
        guard dismissCodition else {
            return false
        }
        let shouldDismiss = bottomSheetPresentableLifecycle?.bottomSheetShouldDismiss() ?? true
        return shouldDismiss
    }
    
    private func endStateFor(forProgress progress: CGFloat, panData: PanData) -> BottomSheetViewState {
        
        if bottomSheetViewState == .fullScreen {
            let shouldCollapse = progress < BottomSheetSpec.collapseThreshold
                                 || panData.velocity.y > BottomSheetSpec.velocityThreshold
            return shouldCollapse ? .bottomSheet : .fullScreen
        } else {
            let shouldExpand = progress > BottomSheetSpec.expandThreshold
                               || panData.velocity.y < -BottomSheetSpec.velocityThreshold
            return shouldExpand ? .fullScreen : .bottomSheet
        }
    }
    
    private func getMinimumBottomSheetHeight(
        inContainerView containerView: UIView,
        bottomSheetHeightProvider: BottomSheetHeightProvider? = nil) -> CGFloat
    {
        let heightProvider = bottomSheetHeightProvider ?? self.bottomSheetHeightProvider
        
        if bottomSheetViewState == .fullScreen && !configuration.allowStateChange {
            return containerView.frame.height
        }
        
        let result = heightProvider.bottomSheetHeight(forContainerSize: containerView.frame.size)
        return result > 0 ? result : BottomSheetSpec.defaultHeight
    }
    
    private func getTopOffset() -> CGFloat {
        if #available(iOS 11.0, *) {
            return presentingViewController.view.safeAreaInsets.top
        } else {
            return presentingViewController.defaultContentInsets.top
        }
    }
    
    // MARK: - Gesture Action Handlers -
    @objc private func onDimmingViewTap(sender: UITapGestureRecognizer) {
        
        let onManualDismiss = configuration.onManualDismiss
        if case .ended = sender.state {
            presentingViewController.dismiss(animated: true) {
                onManualDismiss?()
            }
        }
    }
    
    @objc private func onPresentedViewControllerPan(sender: UIPanGestureRecognizer) {
        guard let presentedView = presentedView else { return }
        guard let containerView = containerView else { return }
        
        let panData = PanData(
            presentedView: presentedView,
            containerView: containerView,
            gestureRecognizer: sender
        )
        
        switch sender.state {
        case .began:
            processPanBegan(with: panData, sender: sender)
        case .changed:
            processPanChange(with: panData)
        case .ended:
            processPanEnd(with: panData)
        case .cancelled, .failed:
            processPanCanceled()
        case .possible:
            break
        @unknown default:
            break
        }
    }
    
    // MARK: - Pan Processing -
    private var panStartOriginY: CGFloat = 0
    
    private func processPanBegan(with panData: PanData, sender: UIPanGestureRecognizer) {
        panStartOriginY = presentedView?.frame.origin.y ?? 0
        isPanInProgress = true
        
        panCachingBottomSheetHeightProvider = CachingBottomSheetHeightProvider(heightProvider: bottomSheetHeightProvider)
        panCachingBottomSheetHeightProvider?.cacheHeight(forContainerSize: panData.containerView.frame.size)
        
        smoothingTranslationY = 0
        
        let scrollViews = bottomSheetScrollProvider.bottomSheetScrollViews()
        let activeScrollView = scrollViews.first { $0.point(inside: sender.location(in: $0), with: nil) }
        
        self.activeScrollView = activeScrollView
        isPanBeganWithScrollView = activeScrollView != nil
    }
    
    private func processPanChange(with panData: PanData) {
        guard isNotScrollViewDidScroll else {
            smoothingTranslationY = panData.translation.y
            return
        }

        let minimumBottomSheetHeight = getMinimumBottomSheetHeight(
            inContainerView: panData.containerView,
            bottomSheetHeightProvider: panCachingBottomSheetHeightProvider
        )
        let newPositionY = panStartOriginY + panData.translation.y - smoothingTranslationY
        let newHeight = panData.containerView.bounds.size.height - newPositionY - keyboardOffset

        if isPanBeganWithScrollView && newPositionY < panStartOriginY {
            let containerHeight = panData.containerView.bounds.size.height
            let presentedHeight = containerHeight - panStartOriginY - keyboardOffset
            
            presentedView?.frame.origin.y = panStartOriginY
            presentedView?.frame.size.height = presentedHeight
            
        } else if newHeight < minimumBottomSheetHeight - 1 {
            let progress = 1 - newHeight / minimumBottomSheetHeight
            dimmingView?.alpha = 1 - progress
            
            presentedView?.frame.origin.y = newPositionY
            presentedView?.frame.size.height = minimumBottomSheetHeight
            
        } else {
            dimmingView?.alpha = 1

            var maxAllowedHeight: CGFloat = containerView?.bounds.height ?? 0
        
            if bottomSheetViewState == .bottomSheet &&
               configuration.allowStateChange == false
            {
                maxAllowedHeight = getPresentedViewFrame(bottomSheetHeightProvider: panCachingBottomSheetHeightProvider).size.height
            }

            if newHeight > maxAllowedHeight
               && maxAllowedHeight > 0
            {
                let height = CGFloat(
                    Double(maxAllowedHeight) * (1 + log10(Double(newHeight / maxAllowedHeight)))
                )
                presentedView?.frame.origin.y = panData.containerView.bounds.size.height - height - keyboardOffset
                presentedView?.frame.size.height = height
            } else {
                presentedView?.frame.origin.y = newPositionY
                presentedView?.frame.size.height = newHeight
            }
        }
    }
    
    private func processPanEnd(with panData: PanData) {
        isPanInProgress = false
        defer { activeScrollView = nil }
        
        guard isNotScrollViewDidScroll else { return }
        
        let minimumBottomSheetHeight = getMinimumBottomSheetHeight(inContainerView: panData.containerView)
        let newPositionY = panStartOriginY + panData.translation.y - smoothingTranslationY
        let newHeight = panData.containerView.bounds.size.height - newPositionY - keyboardOffset

        if newHeight < minimumBottomSheetHeight - 1 {
            
            let progress = 1 - newHeight / minimumBottomSheetHeight

            if shouldCompleteTransition(forProgress: progress, panData: panData) {
                dismissTransitionController.finishInteractiveDismissTransition(withViewController: presentingViewController) { [weak self] in
                    self?.configuration.onManualDismiss?()
                }
            } else {
                setBottomSheetViewState(state: bottomSheetViewState, animated: true)
            }

        } else {
            
            let progress = (newHeight - minimumBottomSheetHeight) / (panData.containerView.bounds.size.height - minimumBottomSheetHeight)
            let newState = endStateFor(forProgress: progress, panData: panData)
            
            setBottomSheetViewState(state: newState, animated: true)
        }
    }
    
    private func processPanCanceled() {
        isPanInProgress = false
        activeScrollView = nil
        setBottomSheetViewState(state: bottomSheetViewState, animated: true)
    }
    
    // MARK: - Keyboard Handling -
    @objc private func onKeyboardWillChangeFrame(_ notification: Notification) {
        guard let info = (notification as NSNotification).userInfo else { return }
        guard let animationDuration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }
        guard let keyboardFrameEnd = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        guard let viewAnimationCurveValue = (info[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uint32Value else { return }
        let alignedAnimationCurveValue = Int(viewAnimationCurveValue >> 1)
        guard let viewAnimationCurve = UIView.AnimationCurve(rawValue: alignedAnimationCurveValue > 3 ? alignedAnimationCurveValue : 0) else { return }
        
        keyboardFrame = keyboardFrameEnd
        
        let curveOption: UIView.AnimationOptions
        
        switch viewAnimationCurve {
        case .easeIn:
            curveOption = .curveEaseIn
        case .easeInOut:
            curveOption = .curveEaseInOut
        case .easeOut:
            curveOption = .curveEaseOut
        case .linear:
            curveOption = .curveLinear
        default:
            curveOption = .curveEaseInOut
        }

        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            options: [curveOption, .allowUserInteraction, .beginFromCurrentState, .layoutSubviews],
            animations: { [weak self] in
                self?.presentedView?.frame = self?.getPresentedViewFrame() ?? .zero
            },
            completion: nil
        )
    }
    
    // MARK: - ScrollView Handing
    private var isNotScrollViewDidScroll: Bool {
        let offsetY = activeScrollView?.contentOffset.y ?? 0
        let isScrolledToTop = offsetY <= 0
        
        return !isPanBeganWithScrollView || isScrolledToTop
    }
    
    private func setScrollViewKVOObserver() {
        let scrollViews = bottomSheetScrollProvider.bottomSheetScrollViews()
        
        for scrollView in scrollViews {
            let scrollViewKVO = KeyValueObserver()
            scrollViewKVO.object = scrollView
            scrollViewKVO.setObserver(
                { [weak self] _ in
                    self?.scrollViewDidScroll(scrollView)
                },
                keyPath: "contentOffset"
            )
            scrollViewKVOs.append(scrollViewKVO)
            scrollViewDidScroll(scrollView)
        }
    }
    
    private func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let presentedView = presentedView else { return }
        
        if scrollView.contentOffset.y > 0 {
            scrollView.bounces = true
        } else if !scrollView.isDecelerating {
            scrollView.bounces = false
        }
        
        if isPanBeganWithScrollView && panStartOriginY < presentedView.frame.origin.y {
            scrollView.contentOffset.y = 0
        }
    }
}
