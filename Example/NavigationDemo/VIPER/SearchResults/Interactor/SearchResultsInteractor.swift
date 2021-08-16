import Foundation

protocol SearchResultsInteractor: AnyObject {
    func category(_ completion: () -> ())
    func categoryTitle(_ completion: (_ title: String?) -> ())
    func searchResults(_ completion: (_ searchResults: [SearchResult]) -> ())
}
