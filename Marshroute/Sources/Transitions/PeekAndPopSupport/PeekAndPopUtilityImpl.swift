import UIKit

public final class PeekAndPopUtilityImpl: 
    NSObject,
    PeekAndPopUtility,
    UIViewControllerPreviewingDelegate,
    PeekAndPopTransitionsCoordinator 
{
    // MARK: - State
    private var registeredPreviewingDataList = [RegisteredPreviewingData]()
    private var peekState: PeekState = .finished 
    
    // MARK: - PeekAndPopUtility
    @available(iOS 9.0, *)
    public func register(
        viewController: UIViewController, 
        sourceView: UIView,
        onPeek: @escaping ((_ previewingContext: UIViewControllerPreviewing, _ location: CGPoint) -> ()))
        -> UIViewControllerPreviewing
    {
        unregister(viewController: viewController, sourceView: sourceView)
        
        let previewingContext = viewController.registerForPreviewing(with: self, sourceView: sourceView)
        
        let registeredPreviewingData = RegisteredPreviewingData(
            viewController: viewController,
            previewingContext: previewingContext,
            onPeek: onPeek
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
    public func previewingContext(
        _ previewingContext: UIViewControllerPreviewing,
        viewControllerForLocation location: CGPoint)
        -> UIViewController? 
    {
        // Prepare to receive peek and pop data
        peekState = .waitingForPeekAndPopData
        
        // Invoke callback to force some router to perform transition
        let registeredPreviewingData = registeredPreviewingDataFor(previewingContext: previewingContext)
        registeredPreviewingData?.onPeek(previewingContext, location)
        
        // Check if router requested a transition
        let didTransitionToInProgressState = peekState.transitionToInProgressState()
        if !didTransitionToInProgressState {
            debugPrint("You were supposed to force some router to make some transition within `onPeek`")
            peekState = .finished
        }
        
        return peekState.viewController
    }
    
    public func previewingContext(
        _ previewingContext: UIViewControllerPreviewing,
        commit viewControllerToCommit: UIViewController)
    {
        // Commit peek
        peekState.popAction?()
        peekState = .finished
    }
    
    // MARK: - PeekAndPopTransitionsCoordinator
    public func coordinatePeekIfNeededFor(
        viewController: UIViewController,
        popAction: @escaping (() -> ()))
    {
        let didTransitionsToReceivedPeekAndPopDataState = peekState.transitionToReceivedPeekAndPopDataState(
            viewController: viewController,
            popAction: popAction
        )
        
        if !didTransitionsToReceivedPeekAndPopDataState {
            // No peek appears to be expected. Invoke transition as usually
            popAction()
        }
    }
    
    // MARK: - Private
    private func registeredPreviewingDataFor(previewingContext: UIViewControllerPreviewing)
        -> RegisteredPreviewingData?
    {
        registeredPreviewingDataList = registeredPreviewingDataList.filter { !$0.isZombie }
        
        return registeredPreviewingDataList.first { $0.previewingContext === previewingContext }
    }
    
    private func cancelPeek() {
        // TODO: проверить что при отмене peek and pop не пересоздаются gesture recongnizers
        // (проверить через addTarget)
        assertionFailure("TODO")
    }
}

private struct RegisteredPreviewingData {
    weak var viewController: UIViewController?
    weak var previewingContext: UIViewControllerPreviewing?
    var onPeek: ((_ previewingContext: UIViewControllerPreviewing, _ location: CGPoint) -> ())
    
    var isZombie: Bool {
        return viewController == nil || previewingContext == nil
    }
}
