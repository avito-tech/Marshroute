import Foundation

protocol SearchResultsCacher: class {
    func cache(searchResult: SearchResult)
    func cached(searchResultId: SearchResultId) -> SearchResult?
}
