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
    
    var viewController: UIViewController? {
        switch self {
        case .waitingForPeekAndPopData:
            return nil
            
        case .receivedPeekAndPopData:
            return nil
            
        case .inProgress(let peekAndPopData):
            return peekAndPopData.peekViewController
            
        case .finished:
            return nil
        }
    }
    
    var popAction: (() -> ())? {
        switch self {
        case .waitingForPeekAndPopData:
            return nil
            
        case .receivedPeekAndPopData:
            return nil
            
        case .inProgress(let peekAndPopData):
            return peekAndPopData.popAction
            
        case .finished:
            return nil
        }
    }
}
