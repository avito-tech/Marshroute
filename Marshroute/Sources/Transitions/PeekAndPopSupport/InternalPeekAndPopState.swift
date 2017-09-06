import UIKit

enum InternalPeekAndPopState {
    case waitingForPeekAndPopData
    case receivedPeekAndPopData(PeekAndPopData)
    case inProgress(PeekAndPopData)
    case finished(isPeekCommited: Bool)

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
    
    var isPeekCommited: Bool {
        switch self {
        case .waitingForPeekAndPopData:
            return false
            
        case .receivedPeekAndPopData:
            return false
            
        case .inProgress:
            return false
            
        case .finished(let isPeekCommited):
            return isPeekCommited
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
