import UIKit

enum InternalPeekAndPopState {
    case waitingForPeekAndPopData(sourceViewControllerBox: WeakBox<UIViewController>)
    case receivedPeekAndPopData(PeekAndPopData)
    case inProgress(PeekAndPopData)
    case finished(isPeekCommitted: Bool)

    var peekAndPopDataIfReceived: PeekAndPopData? {
        switch self {
        case .waitingForPeekAndPopData:
            return nil
            
        case .receivedPeekAndPopData(let peekAndPopData):
            return peekAndPopData
            
        case .inProgress:
            return nil // See computed property's name
            
        case .finished:
            return nil
        }
    }
    
    var isPeekCommitted: Bool {
        switch self {
        case .waitingForPeekAndPopData:
            return false
            
        case .receivedPeekAndPopData:
            return false
            
        case .inProgress:
            return false
            
        case .finished(let isPeekCommitted):
            return isPeekCommitted
        }
    }
    
    var viewControllerIfPeekIsInProgress: UIViewController? {
        switch self {
        case .waitingForPeekAndPopData:
            return nil
            
        case .receivedPeekAndPopData:
            return nil // See computed property's name
            
        case .inProgress(let peekAndPopData):
            return peekAndPopData.peekViewController
            
        case .finished:
            return nil
        }
    }
    
    var popActionIfPeekIsInProgress: (() -> ())? {
        switch self {
        case .waitingForPeekAndPopData:
            return nil
            
        case .receivedPeekAndPopData:
            return nil // See computed property's name
            
        case .inProgress(let peekAndPopData):
            return peekAndPopData.popAction
            
        case .finished:
            return nil
        }
    }
}
