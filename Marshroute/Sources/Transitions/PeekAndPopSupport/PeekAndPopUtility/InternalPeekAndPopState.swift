import UIKit

enum InternalPeekAndPopState {
    case waitingForPeekAndPopData(PeekRequestData)
    case receivedPeekAndPopData(StrongPeekAndPopData)
    case inProgress(WeakPeekAndPopData)
    case finished(isPeekCommitted: Bool)

    var peekAndPopDataIfReceived: StrongPeekAndPopData? {
        switch self {
        case .waitingForPeekAndPopData:
            return nil
            
        case .receivedPeekAndPopData(let strongPeekAndPopData):
            return strongPeekAndPopData
            
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
            
        case .inProgress(let weakPeekAndPopData):
            return weakPeekAndPopData
            
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
