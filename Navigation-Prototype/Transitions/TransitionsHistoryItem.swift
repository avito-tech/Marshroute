import Foundation

struct TransitionsHistoryItem {
    let stackClient: TransitionContextsStackClient
    
    weak var transitionsHandler: TransitionsHandler? {
        didSet {
            if transitionsHandler == nil {
                delegate?.transitionsHistoryItemDidLooseTransitionsHandler(self)
            }
        }
    }
    
    weak var delegate: TransitionsHistoryItemDelegate?
    
    init (stackClient: TransitionContextsStackClient,
        transitionsHandler: TransitionsHandler)
    {
        self.stackClient = stackClient
        self.transitionsHandler = transitionsHandler
    }
}