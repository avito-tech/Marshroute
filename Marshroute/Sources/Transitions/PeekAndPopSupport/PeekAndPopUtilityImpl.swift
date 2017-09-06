import UIKit

public final class PeekAndPopUtilityImpl: 
    NSObject,
    PeekAndPopUtility,
    UIViewControllerPreviewingDelegate,
    PeekAndPopTransitionsCoordinator ,
    PeekAndPopStateObservable,
    PeekAndPopStateViewControllerObservable
{
    // MARK: - State
    private var registeredPreviewingDataList = [RegisteredPreviewingData]()
    private var peekState: PeekState = .finished
    
    private weak var peekGestureRecognizer: UIGestureRecognizer? {
        didSet {
            oldValue?.removeTarget(self, action: nil)
            peekGestureRecognizer?.addTarget(self, action: #selector(onPeekGestureChange(_:)))
        }
    }
    
    private var peekAndPopStateObservers = [PeekAndPopStateObserver]()
    
    // MARK: - PeekAndPopUtility
    @available(iOS 9.0, *)
    public func register(
        viewController: UIViewController, 
        sourceView: UIView,
        onPeek: @escaping ((_ previewingContext: UIViewControllerPreviewing, _ location: CGPoint) -> ()),
        onPreviewingContextChange: ((_ newPreviewingContext: UIViewControllerPreviewing) -> ())?)
        -> UIViewControllerPreviewing
    {
        unregister(viewController: viewController, sourceView: sourceView)
        
        if viewController.traitCollection.forceTouchCapability != .available {
            debugPrint("You should not register a viewController for `peek and pop`, "
                + "if it is unavailable in a trait collection: \(viewController)")
        }
        
        let previewingContext = viewController.registerForPreviewing(
            with: self,
            sourceView: sourceView
        )
        
        let registeredPreviewingData = RegisteredPreviewingData(
            viewController: viewController,
            previewingContext: previewingContext,
            onPeek: onPeek,
            onPreviewingContextChange: onPreviewingContextChange
        )
        
        registeredPreviewingDataList.append(registeredPreviewingData)
        
        return previewingContext
    }
    
    @available(iOS 9.0, *)
    public func unregister(viewController: UIViewController, sourceView: UIView?) {
        registeredPreviewingDataList = registeredPreviewingDataList.filter { registeredPreviewingData in
            let shouldKeepInCollection: Bool
            
            if registeredPreviewingData.isZombie {
                shouldKeepInCollection = false
            } else if registeredPreviewingData.viewController == viewController {
                if let sourceView = sourceView {
                    shouldKeepInCollection = registeredPreviewingData.previewingContext?.sourceView != sourceView
                } else {
                    shouldKeepInCollection = false
                }
            } else {
                shouldKeepInCollection = true
            }
            
            return shouldKeepInCollection
        }
    }
    
    // MARK: - UIViewControllerPreviewingDelegate
    @available(iOS 9.0, *)
    public func previewingContext(
        _ previewingContext: UIViewControllerPreviewing,
        viewControllerForLocation location: CGPoint)
        -> UIViewController? 
    {
        // Prepare to receive `peek and pop` data
        peekState = .waitingForPeekAndPopData
        
        // Invoke callback to force some router to perform transition
        let onscreenRegisteredPreviewingData = onscreenRegisteredPreviewingDataFor(previewingContext: previewingContext)
        onscreenRegisteredPreviewingData?.onPeek(previewingContext, location)
        
        // Check if router requested a transition
        let didTransitionToInProgressState = peekState.transitionToInProgressState()
        
        if didTransitionToInProgressState {
            peekGestureRecognizer = previewingContext.previewingGestureRecognizerForFailureRelationship
        } else {
            debugPrint("You were supposed to force some router to make some transition within `onPeek`")
            resetPeekStateAndNotifyObservers()
        }
        
        if let peekViewController = peekState.viewControllerIfPeekIsInProgress {
            notifyPeekAndPopStateObserversOn(
                viewController: peekViewController,
                beingInPeekState: true
            )
            return peekViewController
        } else {
            return nil
        }
    }
    
    @available(iOS 9.0, *)
    public func previewingContext(
        _ previewingContext: UIViewControllerPreviewing,
        commit viewControllerToCommit: UIViewController)
    {
        // Commit peek
        peekState.popActionIfPeekIsInProgress?()
        resetPeekStateAndNotifyObservers()
    }
    
    // MARK: - PeekAndPopTransitionsCoordinator
    public func coordinatePeekIfNeededFor(
        viewController: UIViewController,
        popAction: @escaping (() -> ()))
    {
        guard #available(iOS 9.0, *) else {
            // `Peek and pop` is not supported on older iOS versions. Invoke new transition immediately
            popAction()
            return
        }
        
        switch peekState {
        case .waitingForPeekAndPopData:
            var rollbackUnbindingViewControllerFromParent: (() -> ())?
            
            unbindViewControllerFromParent(
                viewController: viewController,
                rollback: &rollbackUnbindingViewControllerFromParent
            )
 
            
            let peekAndPopData = PeekAndPopData(
                peekViewController: viewController,
                popAction: {
                    rollbackUnbindingViewControllerFromParent?()
                    popAction()
                }
            )
            
            peekState = .receivedPeekAndPopData(peekAndPopData)
            
        case .receivedPeekAndPopData(let peekAndPopData):
            // Another transition seems to occur during `peek`. Cancel `peek` and invoke new transition immediately
            cancelPeekFor(peekAndPopData: peekAndPopData)
            popAction()
            
        case .inProgress(let peekAndPopData):
            // Another transition seems to occur during `peek`. Cancel `peek` and invoke new transition immediately
            cancelPeekFor(peekAndPopData: peekAndPopData)
            popAction()
            
        case .finished:
            // No active `peek` seems to be in progress. Invoke new transition immediately
            popAction()
        }
    }
    
    // MARK: - PeekAndPopStateObservable
    public func addObserver(
        disposable: AnyObject,
        onPeekAndPopStateChange: @escaping ((_ viewController: UIViewController, _ isInPeekState: Bool) -> ()))
    {
        peekAndPopStateObservers = peekAndPopStateObservers.filter { !$0.isZombie }
        
        let peekAndPopStateObserver = PeekAndPopStateObserver(
            disposable: disposable,
            onPeekAndPopStateChange: onPeekAndPopStateChange
        )
        
        peekAndPopStateObservers.append(peekAndPopStateObserver)
        
        // Invoke callback immediately no feed a new observer with the latest data
        if let peekViewController = peekState.viewControllerIfPeekIsInProgress {
            let isInPeekState = true
            onPeekAndPopStateChange(peekViewController, isInPeekState)
        }
    }
    
    // MARK: - Private
    @available(iOS 9.0, *)
    private func onscreenRegisteredPreviewingDataFor(previewingContext: UIViewControllerPreviewing)
        -> RegisteredPreviewingData?
    {
        registeredPreviewingDataList = registeredPreviewingDataList.filter { !$0.isZombie }
        
        let matchingRegisteredPreviewingData = registeredPreviewingDataList.first { $0.previewingContext === previewingContext }
        
        return matchingRegisteredPreviewingData?.isOnscreen == true
            ? matchingRegisteredPreviewingData
            : nil
    }
    
    @available(iOS 9.0, *)
    private func registeredPreviewingDataListFor(viewController: UIViewController?)
        -> [RegisteredPreviewingData]
    {
        registeredPreviewingDataList = registeredPreviewingDataList.filter { !$0.isZombie }
        
        return registeredPreviewingDataList.filter { $0.viewController === viewController }
    }
    
    @available(iOS 9.0, *)
    private func cancelPeekFor(peekAndPopData: PeekAndPopData) {
        resetPeekStateAndNotifyObservers()
        
        guard let viewController = peekAndPopData.peekViewController else {
            return
        }
        
        // Cancelling `peek and pop` may be implemented via reregistering a `viewController` for previewing
        let registeredPreviewingDataList = registeredPreviewingDataListFor(viewController: viewController) 
        
        for registeredPreviewingData in registeredPreviewingDataList {
            guard let sourceView = registeredPreviewingData.previewingContext?.sourceView else {
                continue
            }
            
            debugPrint("Cancelling `peek` for viewController: \(viewController)")
            
            // Reregister a `viewController` for previewing
            let newPreviewingContext = reregister(
                viewController: viewController,
                sourceView: sourceView,
                onPeek: registeredPreviewingData.onPeek,
                onPreviewingContextChange: registeredPreviewingData.onPreviewingContextChange
            )
            
            // Notify about a reregister
            registeredPreviewingData.onPreviewingContextChange?(newPreviewingContext)
        }
    }
    
    private func resetPeekStateAndNotifyObservers() {
        if let peekViewController = peekState.viewControllerIfPeekIsInProgress {
            notifyPeekAndPopStateObserversOn(
                viewController: peekViewController,
                beingInPeekState: false
            )
        }
            
        peekState = .finished
        peekGestureRecognizer = nil
    }
    
    private func notifyPeekAndPopStateObserversOn(
        viewController: UIViewController,
        beingInPeekState isInPeekState: Bool)
    {
        peekAndPopStateObservers = peekAndPopStateObservers.filter { !$0.isZombie }
        
        peekAndPopStateObservers.forEach {
            $0.onPeekAndPopStateChange(viewController, isInPeekState)
        }
    }
    
    private func unbindViewControllerFromParent(
        viewController: UIViewController,
        rollback: inout (() -> ())?)
    {
        if let navigationController = viewController.navigationController {
            // (*) If you present a `viewController` in a `peek` mode, 
            // whereas the `viewController` is already embeded into a `parent` controller 
            // (i.e.: `UINavigationController` and/or probably `UIPopoverController`),
            // then `UIKit` will require you to unbind the `viewController` from its `parent`
            let filteredViewControllers = navigationController.viewControllers.filter { $0 !== viewController }
            navigationController.viewControllers = filteredViewControllers
            
            rollback = {
                // Return `viewController` back to its `parent`
                let restoredViewControllers = navigationController.viewControllers + [viewController]
                navigationController.viewControllers = restoredViewControllers                        
            }
        }
        
        if viewController.parent != nil {
            // Probably an unhandled edge case. See (*) for details
            debugPrint(
                "The following `peek` may crash your app with `NSInvalidArgumentException` \n"
                    + "reason: 'Application tried to present modally an active controller ...'. \n"
                    + "If so, please report an issue at a github repo page"
            )
        }
    }
    
    @objc private func onPeekGestureChange(_ sender: UIGestureRecognizer) {
        // When a user cancels `peek`, gesture recognizer's state is `.ended`
        // When a user commits `peek`, gesture recognizer's state is `.cancelled`
        if sender.state == .ended {
            // Release the `peek` view controller
            resetPeekStateAndNotifyObservers()
        }
    }
}

private struct RegisteredPreviewingData {
    weak var viewController: UIViewController?
    weak var previewingContext: UIViewControllerPreviewing?
    var onPeek: ((_ previewingContext: UIViewControllerPreviewing, _ location: CGPoint) -> ())
    var onPreviewingContextChange: ((_ newPreviewingContext: UIViewControllerPreviewing) -> ())?
    
    @available(iOS 9.0, *)
    var isZombie: Bool {
        return viewController == nil || previewingContext == nil || previewingContext?.sourceView == nil
    }
    
    @available(iOS 9.0, *)
    var isOnscreen: Bool {
        return previewingContext?.sourceView.window != nil && viewController?.view.window != nil
    }
}

private struct PeekAndPopStateObserver {
    weak var disposable: AnyObject?
    var onPeekAndPopStateChange: ((_ viewController: UIViewController, _ isInPeekState: Bool) -> ())   
    
    var isZombie: Bool {
        return disposable == nil
    }
}
