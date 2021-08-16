import Foundation

protocol SearchResultsCacher: AnyObject {
    func cache(searchResult: SearchResult)
    func cached(searchResultId: SearchResultId) -> SearchResult?
}
