import UIKit

enum PeekState {
    case waitingForPeekAndPopData
    case receivedPeekAndPopData(PeekAndPopData)
    case inProgress(PeekAndPopData)
    case finished

    mutating func transitionToInProgressState() -> Bool {
        switch self {
        case .waitingForPeekAndPopData:
            return false
            
        case .receivedPeekAndPopData(let peekAndPopData):
            self = .inProgress(peekAndPopData)
            return true
            
        case .inProgress:
            return false
            
        case .finished:
            return false
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
