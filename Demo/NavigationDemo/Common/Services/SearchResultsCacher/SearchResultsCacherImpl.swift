import Foundation

final class SearchResultsCacherImpl: SearchResultsCacher {
    // MARK: - Private properties
    private var cache = [SearchResultId: SearchResult]()
    
    // MARK: - SearchResultsCacher
    func cache(searchResult searchResult: SearchResult) {
        cache[searchResult.id] = searchResult
    }
    
    func cached(searchResultId searchResultId: SearchResultId) -> SearchResult? {
        return cache[searchResultId]
    }
}