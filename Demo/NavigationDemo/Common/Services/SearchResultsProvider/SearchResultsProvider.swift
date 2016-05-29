import Foundation

typealias SearchResultId = String

struct SearchResult {
    let title: String
    let id: SearchResultId
    let rgb: (red: Double, green: Double, blue: Double)
    let requiresAuthorization: Bool
    let patternAssetName: String?
    let placeholderAssetName: String?
}

protocol SearchResultsProvider: class {
    func searchResults(categoryId categoryId: CategoryId, count: Int) -> [SearchResult]
    func searchResult(searchResultId searchResultId: SearchResultId) -> SearchResult
    func recommendedSearchResults(searchResultId searchResultId: SearchResultId) -> [SearchResult]
}