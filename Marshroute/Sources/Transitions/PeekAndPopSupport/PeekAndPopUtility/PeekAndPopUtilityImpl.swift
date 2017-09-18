import UIKit

public final class PeekAndPopUtilityImpl: 
    NSObject,
    PeekAndPopUtility,
    UIViewControllerPreviewingDelegate,
    PeekAndPopTransitionsCoordinator,
    PeekAndPopStateObservable,
    PeekAndPopStateViewControllerObservable
{
    // MARK: - State
    private var registeredPreviewingDataList = [RegisteredPreviewingData]()
    
    private var internalPeekAndPopState: InternalPeekAndPopState = .finished(isPeekCommitted: false) {
        didSet {
            notifyPeekAndPopStateObserversIfNeededOn(
                internalPeekAndPopState: internalPeekAndPopState,
                oldInternalPeekAndPopState: oldValue
            )
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
            debugPrint("You should not register a view controller for `peek and pop`, "
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
            } else if registeredPreviewingData.viewController === viewController,
                let previewingContext = registeredPreviewingData.previewingContext 
            {
                if let sourceView = sourceView {
                    shouldKeepInCollection = previewingContext.sourceView !== sourceView
                } else {
                    shouldKeepInCollection = false
                }
                
                if !shouldKeepInCollection {
                    viewController.unregisterForPreviewing(withContext: previewingContext)
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
        if let onscreenRegisteredPreviewingData = onscreenRegisteredPreviewingDataFor(previewingContext: previewingContext),
            let onscreenRegisteredViewController = onscreenRegisteredPreviewingData.viewController 
        {
            // `UIKit` may invoke this method several times in a loop for every matching `peek` source view.
            // In this case we should check whether previous `peek` request was satisfied and cancel current `peek` request
            let isRequestedPeekAlreadyInProgress = checkIfPeekIsAlreadyInProgressFor(
                previewingContext: previewingContext,
                location: location
            )
            
            if isRequestedPeekAlreadyInProgress {
                // Cancel `peek` request
                return nil
            }
            
            let peekRequestData = PeekRequestData(
                previewingContext: previewingContext,
                sourceViewController: onscreenRegisteredViewController,
                peekLocation: location
            )
            
            // Prepare to receive `peek and pop` data
            internalPeekAndPopState = .waitingForPeekAndPopData(peekRequestData)
            
            // Invoke callback that finally forces some router to perform a transition,
            // that will be intercepted within `PeekAndPopTransitionsCoordinator` implementation
            onscreenRegisteredPreviewingData.onPeek(previewingContext, location)
            
            // Check if router requested a transition
            if let peekAndPopData = internalPeekAndPopState.peekAndPopDataIfReceived {
                internalPeekAndPopState = .inProgress(peekAndPopData.toWeakPeekAndPopData())
                return peekAndPopData.peekViewController
            } else {
                internalPeekAndPopState = .finished(isPeekCommitted: false)
                return nil
            }
        } else {
            // Cancel `peek`
            internalPeekAndPopState = .finished(isPeekCommitted: false)
            return nil
        }
    }
    
    @available(iOS 9.0, *)
    public func previewingContext(
        _ previewingContext: UIViewControllerPreviewing,
        commit viewControllerToCommit: UIViewController)
    {
        let peekAndPopData = internalPeekAndPopState.peekAndPopDataIfReceived
            ?? internalPeekAndPopState.peekAndPopDataIfPeekIsInProgress
        
        if let peekAndPopData = peekAndPopData, 
            let peekViewController = peekAndPopData.peekViewController
        {
            if peekViewController === viewControllerToCommit {
                // Commit peek
                peekAndPopData.popAction()
                internalPeekAndPopState = .finished(isPeekCommitted: true)
            } else {
                cancelPeekFor(
                    peekAndPopData: peekAndPopData,
                    reason: .popIsRequestedToAnotherViewController(viewControllerToCommit)
                )
            } 
        } else {
            internalPeekAndPopState = .finished(isPeekCommitted: false)
        }
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
        case .waitingForPeekAndPopData(let peekRequestData):
            var rollbackUnbindingViewControllerFromParent: (() -> ())?
            
            let peekCancellationReason = unbindViewControllerFromParent(
                viewController: viewController,
                rollback: &rollbackUnbindingViewControllerFromParent
            )
            
            let peekAndPopData = StrongPeekAndPopData(
                peekViewController: viewController,
                sourceViewController: peekRequestData.sourceViewController,
                previewingContext: peekRequestData.previewingContext,
                peekLocation: peekRequestData.peekLocation,
                popAction: {
                    rollbackUnbindingViewControllerFromParent?()
                    popAction()
                }
            )
            
            if let peekCancellationReason = peekCancellationReason {
                cancelPeekFor(
                    peekAndPopData: peekAndPopData,
                    reason: peekCancellationReason
                )
            } else {
                // Store a `peek` view controller to use within `UIViewControllerPreviewingDelegate`'s implementation
                // and thus start a `peek and pop` session
                internalPeekAndPopState = .receivedPeekAndPopData(peekAndPopData)                
            }
            
        case .receivedPeekAndPopData(let peekAndPopData):
            // Another transition seems to occur during `peek`. Cancel `peek` and invoke new transition immediately
            cancelPeekFor(
                peekAndPopData: peekAndPopData,
                reason: .isInterruptedByTransitionToAnotherViewController(viewController)
            )
            popAction()
            
        case .inProgress(let weakPeekAndPopData):
            // Another transition seems to occur during `peek`. Cancel `peek` and invoke new transition immediately
            cancelPeekFor(
                peekAndPopData: weakPeekAndPopData,
                reason: .isInterruptedByTransitionToAnotherViewController(viewController)
            )
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
        
        // Invoke callback immediately to introduce current state to a new observer
        if let peekViewController = internalPeekAndPopState.peekViewControllerIfPeekIsInProgress {
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
    private func checkIfPeekIsAlreadyInProgressFor(
        previewingContext: UIViewControllerPreviewing,
        location: CGPoint)
        -> Bool
    { 
        if let peekAndPopData = internalPeekAndPopState.peekAndPopDataIfPeekIsInProgress,
            let existingPreviewingContext = peekAndPopData.previewingContext,
            peekAndPopData.sourceViewController != nil
        {
            let exisitingSourceView = existingPreviewingContext.sourceView
            let existingPeekLocation = peekAndPopData.peekLocation
            
            let existingPeekLocationInWindow = exisitingSourceView.convert(existingPeekLocation, to: nil)
            let newPeekLocationInWindow = previewingContext.sourceView.convert(location, to: nil)
            
            return existingPeekLocationInWindow == newPeekLocationInWindow
        }
        
        return false
    }
    
    @available(iOS 9.0, *)
    private func registeredPreviewingDataListFor(viewController: UIViewController?)
        -> [RegisteredPreviewingData]
    {
        registeredPreviewingDataList = registeredPreviewingDataList.filter { !$0.isZombie }
        
        return registeredPreviewingDataList.filter { $0.viewController === viewController }
    }
    
    @available(iOS 9.0, *)
    private func cancelPeekFor(peekAndPopData: PeekAndPopData, reason: PeekCancellationReason) {
        if let peekViewController = peekAndPopData.peekViewController,
            let sourceViewController = peekAndPopData.sourceViewController
        {
            let readableCancellationReason: String
            
            switch reason {
            case .isInterruptedByTransitionToAnotherViewController(let targetViewController):
                readableCancellationReason = 
                    "Cancelling `peek` for view controller: \(peekViewController), "
                    + "because it got interrupted by a transition to another view controller: \(targetViewController)"
                
            case .peekViewControllerHasNonNilParent(let parentViewController):
                // See (*) for details
                readableCancellationReason = 
                    "Cancelling `peek` to a view controller: \(peekViewController), "
                    + "because it is has a non nil parent view controller: \(parentViewController). "
                    + "This is done to avoid your app's possible crash your app with `NSInvalidArgumentException` "
                    + "reason: 'Application tried to present modally an active controller ...'."
                    + "If so, please report an issue at a `Marshroute`'s github repo page:"
                    + "https://github.com/avito-tech/Marshroute"
                
            case .popIsRequestedToAnotherViewController(let viewControllerToCommit):
                readableCancellationReason = 
                    "Cancelling `peek` to a view controller: \(peekViewController), "
                    + "because `UIKit` requested `UIViewControllerPreviewingDelegate` "
                    + "to commit another view controller: \(viewControllerToCommit)"
            }
           
            debugPrint(readableCancellationReason)
            
            // Cancelling `peek and pop` may be implemented via reregistering a `sourceViewController` for previewing
            reregisterViewControllerForPreviewing(sourceViewController)
        }
        
        internalPeekAndPopState = .finished(isPeekCommitted: false)
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
        if let peekViewController = internalPeekAndPopState.peekViewControllerIfPeekIsInProgress {
            notifyPeekAndPopStateObserversOn(
                peekAndPopState: .inPeek,
                forViewController: peekViewController
            ) 
        } else if let oldPeekViewController = oldInternalPeekAndPopState.peekViewControllerIfPeekIsInProgress {
            notifyPeekAndPopStateObserversOn(
                peekAndPopState: (internalPeekAndPopState.isPeekCommitted) 
                    ? .popped
                    : .interrupted,
                forViewController: oldPeekViewController
            ) 
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
        -> PeekCancellationReason?
    {
        if let navigationController = viewController.navigationController, 
            let index = navigationController.viewControllers.index(where: { $0 === viewController }) 
        {
            // (*) If you present a `viewController` in a `peek` mode, 
            // whereas the `viewController` is already embeded into a `parent` controller 
            // (i.e.: `UINavigationController` and/or probably `UIPopoverController`),
            // then `UIKit` will require you to unbind the `viewController` from its `parent`
            let filteredViewControllers = navigationController.viewControllers.filter { $0 !== viewController }
            navigationController.viewControllers = filteredViewControllers
            
            func bindViewController(
                _ viewController: UIViewController,
                backToNavigationController navigationController: UINavigationController)
            {
                // Return `viewController` back to its `parent`
                var restoredViewControllers = navigationController.viewControllers
                
                if index < restoredViewControllers.count {
                    restoredViewControllers.insert(viewController, at: index)
                } else {
                    restoredViewControllers.append(viewController)
                }
                
                navigationController.viewControllers = restoredViewControllers                        
            }
            
            if filteredViewControllers.isEmpty {
                rollback = { [weak viewController] in
                    // Retain a strong reference to a `navigationController`.
                    // This is likely to be a modal navigation transition. 
                    guard let viewController = viewController 
                        else { return }
                    
                    // Return `viewController` back to its `parent`
                    bindViewController(viewController, backToNavigationController: navigationController)
                }
            } else {
                rollback = { [weak viewController, weak navigationController] in
                    // Retain a weak reference to a `navigationController`.
                    // This is likely to be a push transition.
                    guard let viewController = viewController,
                        let navigationController = navigationController
                        else { return }
                    
                    // Return `viewController` back to its `parent`
                    bindViewController(viewController, backToNavigationController: navigationController)      
                }
            }
        }
        
        return viewController.parent.flatMap { .peekViewControllerHasNonNilParent($0) } 
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

private enum PeekCancellationReason {
    case isInterruptedByTransitionToAnotherViewController(UIViewController)
    case peekViewControllerHasNonNilParent(UIViewController)
    case popIsRequestedToAnotherViewController(UIViewController)
}
