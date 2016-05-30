import Foundation

protocol SearchResultsInteractor: class {
    func category(completion: () -> ())
    func categoryTitle(completion: (title: String?) -> ())
    func searchResults(completion: (searchResults: [SearchResult]) -> ())
}