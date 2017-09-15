import Foundation

protocol SearchResultsInteractor: class {
    func category(_ completion: () -> ())
    func categoryTitle(_ completion: (_ title: String?) -> ())
    func searchResults(_ completion: (_ searchResults: [SearchResult]) -> ())
}
