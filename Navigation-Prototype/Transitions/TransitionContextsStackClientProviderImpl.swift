import Foundation

final class TransitionContextsStackClientProviderImpl {
    var historyItems = [TransitionsHistoryItem]()
}

// MARK: - TransitionContextsStackClientProvider
extension TransitionContextsStackClientProviderImpl: TransitionContextsStackClientProvider {
    func stackClient(forTransitionsHandler transitionsHandler: TransitionsHandler)
        -> TransitionContextsStackClient?
    {
        let historyItem = historyItems.filter { $0.transitionsHandler === transitionsHandler }
        assert(historyItem.count <= 1)
        return historyItem.first?.stackClient
    }
    
    func createStackClient(forTransitionsHandler transitionsHandler: TransitionsHandler)
        -> TransitionContextsStackClient
    {
        let stackClient = TransitionContextsStackClientImpl()

        let newHistoryItem = TransitionsHistoryItem(
            stackClient: stackClient,
            transitionsHandler: transitionsHandler)
        
        historyItems.append(newHistoryItem)
        
        return stackClient
    }
}

// MARK: - TransitionsHistoryItemDelegate
extension TransitionContextsStackClientProviderImpl: TransitionsHistoryItemDelegate {
    func transitionsHistoryItemDidLooseTransitionsHandler(historyItem: TransitionsHistoryItem)
    {
        if let index = historyItems.indexOf({ $0.stackClient === historyItem.stackClient }) {
            historyItems.removeAtIndex(index)
        }
    }
}