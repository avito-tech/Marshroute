import Foundation

final class TransitionContextsStackClientProviderImpl {
    var historyItems = [TransitionsHistoryItem]()
}

// MARK: - TransitionContextsStackClientProvider
extension TransitionContextsStackClientProviderImpl: TransitionContextsStackClientProvider {
    func stackClient(forTransitionsHandler transitionsHandler: TransitionsHandler)
        -> TransitionContextsStackClient?
    {
        updateHistoryItems()
        
        let matchingHistoryItems = historyItems.filter { $0.transitionsHandler === transitionsHandler }
        
        assert(matchingHistoryItems.count <= 1)
        
        return matchingHistoryItems.first?.stackClient
    }
    
    func createStackClient(forTransitionsHandler transitionsHandler: TransitionsHandler)
        -> TransitionContextsStackClient
    {
        updateHistoryItems()
        
        let stackClient = TransitionContextsStackClientImpl()

        let newHistoryItem = TransitionsHistoryItem(
            stackClient: stackClient,
            transitionsHandler: transitionsHandler)
        
        historyItems.append(newHistoryItem)
        
        return stackClient
    }
}

// MARK: - helpers
private extension TransitionContextsStackClientProviderImpl {
    func updateHistoryItems()
    {
        historyItems = historyItems.filter { $0.transitionsHandler != nil }
    }
}