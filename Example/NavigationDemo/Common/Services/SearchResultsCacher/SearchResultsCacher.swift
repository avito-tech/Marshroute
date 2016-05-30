import Foundation

protocol SearchResultsCacher: class {
    func cache(searchResult searchResult: SearchResult)
    func cached(searchResultId searchResultId: SearchResultId) -> SearchResult?
}
