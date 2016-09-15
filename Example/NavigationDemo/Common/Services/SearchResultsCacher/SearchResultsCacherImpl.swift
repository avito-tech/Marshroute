import Foundation

final class SearchResultsCacherImpl: SearchResultsCacher {
    // MARK: - Private properties
    fileprivate var cache = [SearchResultId: SearchResult]()
    
    // MARK: - SearchResultsCacher
    func cache(searchResult: SearchResult) {
        cache[searchResult.id] = searchResult
    }
    
    func cached(searchResultId: SearchResultId) -> SearchResult? {
        return cache[searchResultId]
    }
}
