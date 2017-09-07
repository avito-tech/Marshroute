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
    
    var peekAndPopDataIfPeekIsInProgress: PeekAndPopData? {
        switch self {
        case .waitingForPeekAndPopData:
            return nil
            
        case .receivedPeekAndPopData:
            return nil // See computed property's name
            
        case .inProgress(let peekAndPopData):
            return peekAndPopData
            
        case .finished:
            return nil
        }
    }
    
    var peekViewControllerIfPeekIsInProgress: UIViewController? {
        return peekAndPopDataIfPeekIsInProgress?.peekViewController
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
}
