import Foundation

protocol TransitionsHistoryItemDelegate: class {
    func transitionsHistoryItemDidLooseTransitionsHandler(historyItem: TransitionsHistoryItem)
}