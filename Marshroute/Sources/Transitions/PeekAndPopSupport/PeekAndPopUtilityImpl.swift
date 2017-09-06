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
    
    private var internalPeekAndPopState: InternalPeekAndPopState = .finished(isPeekCommited: false) {
        didSet {
            releasePeekGestureRecognizerIfNeeded(
                internalPeekAndPopState: internalPeekAndPopState
            )
            
            notifyPeekAndPopStateObserversIfNeededOn(
                internalPeekAndPopState: internalPeekAndPopState,
                oldInternalPeekAndPopState: oldValue
            )
        }
    }
    
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
        forPreviewingInSourceView sourceView: UIView,
        onPeek: @escaping ((_ previewingContext: UIViewControllerPreviewing, _ location: CGPoint) -> ()),
        onPreviewingContextChange: ((_ newPreviewingContext: UIViewControllerPreviewing) -> ())?)
    {
        unregister(
            viewController: viewController,
            fromPreviewingInSourceView: sourceView
        )
        
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
         
        onPreviewingContextChange?(previewingContext)
    }
    
    @available(iOS 9.0, *)
    public func unregister(
        viewController: UIViewController,
        fromPreviewingInSourceView sourceView: UIView?)
    {
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
        internalPeekAndPopState = .waitingForPeekAndPopData
        
        // Invoke callback to force some router to perform transition
        let onscreenRegisteredPreviewingData = onscreenRegisteredPreviewingDataFor(previewingContext: previewingContext)
        onscreenRegisteredPreviewingData?.onPeek(previewingContext, location)
        
        // Check if router requested a transition
        if let peekAndPopData = internalPeekAndPopState.peekAndPopDataIfReceived,
            let peekViewController = peekAndPopData.peekViewController
        {
            internalPeekAndPopState = .inProgress(peekAndPopData)
            peekGestureRecognizer = previewingContext.previewingGestureRecognizerForFailureRelationship
            return peekViewController
        } else {
            debugPrint("You were supposed to force some router to make some transition within `onPeek`")
            internalPeekAndPopState = .finished(isPeekCommited: false)
            return nil
        }
    }
    
    @available(iOS 9.0, *)
    public func previewingContext(
        _ previewingContext: UIViewControllerPreviewing,
        commit viewControllerToCommit: UIViewController)
    {
        // Commit peek
        internalPeekAndPopState.popActionIfPeekIsInProgress?()
        internalPeekAndPopState = .finished(isPeekCommited: true)
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
        
        switch internalPeekAndPopState {
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
            
            internalPeekAndPopState = .receivedPeekAndPopData(peekAndPopData)
            
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
        onPeekAndPopStateChange: @escaping ((_ viewController: UIViewController, _ peekAndPopState: PeekAndPopState) -> ()))
    {
        peekAndPopStateObservers = peekAndPopStateObservers.filter { !$0.isZombie }
        
        let peekAndPopStateObserver = PeekAndPopStateObserver(
            disposable: disposable,
            onPeekAndPopStateChange: onPeekAndPopStateChange
        )
        
        peekAndPopStateObservers.append(peekAndPopStateObserver)
        
        // Invoke callback immediately no notify a new observer about current state
        if let peekViewController = internalPeekAndPopState.viewControllerIfPeekIsInProgress {
            onPeekAndPopStateChange(peekViewController, .inPeek)
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
        if let peekViewController = peekAndPopData.peekViewController {
            // Cancelling `peek and pop` may be implemented via reregistering a `peekViewController` for previewing
            debugPrint("Cancelling `peek` for viewController: \(peekViewController)")
            reregisterViewControllerForPreviewing(peekViewController)
        }
        
        internalPeekAndPopState = .finished(isPeekCommited: false)
    }
    
    @available(iOS 9.0, *)
    private func reregisterViewControllerForPreviewing(_ viewController: UIViewController) {
        let registeredPreviewingDataList = registeredPreviewingDataListFor(viewController: viewController) 
        
        for registeredPreviewingData in registeredPreviewingDataList {
            guard let sourceView = registeredPreviewingData.previewingContext?.sourceView else {
                continue
            }
            
            reregister(
                viewController: viewController,
                forPreviewingInSourceView: sourceView,
                onPeek: registeredPreviewingData.onPeek,
                onPreviewingContextChange: registeredPreviewingData.onPreviewingContextChange
            )
        }
    }
    
    private func notifyPeekAndPopStateObserversIfNeededOn(
        internalPeekAndPopState: InternalPeekAndPopState,
        oldInternalPeekAndPopState: InternalPeekAndPopState)
    {
        if let peekViewController = internalPeekAndPopState.viewControllerIfPeekIsInProgress {
            notifyPeekAndPopStateObserversOn(
                peekAndPopState: .inPeek,
                forViewController: peekViewController
            ) 
        } else if let oldPeekViewController = oldInternalPeekAndPopState.viewControllerIfPeekIsInProgress {
            notifyPeekAndPopStateObserversOn(
                peekAndPopState: (internalPeekAndPopState.isPeekCommited) 
                    ? .popped
                    : .cancelled,
                forViewController: oldPeekViewController
            ) 
        }
    }
    
    private func releasePeekGestureRecognizerIfNeeded(internalPeekAndPopState: InternalPeekAndPopState) {
        switch internalPeekAndPopState {
        case .waitingForPeekAndPopData:
            peekGestureRecognizer = nil

        case .receivedPeekAndPopData:
            peekGestureRecognizer = nil
            
        case .inProgress:
            break
            
        case .finished:
            peekGestureRecognizer = nil   
        }
    }
    
    private func notifyPeekAndPopStateObserversOn(
        peekAndPopState: PeekAndPopState,
        forViewController viewController: UIViewController)
    {
        peekAndPopStateObservers = peekAndPopStateObservers.filter { !$0.isZombie }
        
        peekAndPopStateObservers.forEach {
            $0.onPeekAndPopStateChange(viewController, peekAndPopState)
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
            internalPeekAndPopState = .finished(isPeekCommited: false)
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
    var onPeekAndPopStateChange: ((_ viewController: UIViewController, _ peekAndPopState: PeekAndPopState) -> ())   
    
    var isZombie: Bool {
        return disposable == nil
    }
}
