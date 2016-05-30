import Foundation

struct SearchResultsViewData {
    let title: String
    let rgb: (red: Double, green: Double, blue: Double)
    let onTap: () -> ()
}

protocol SearchResultsViewInput: class, ViewLifecycleObservable {
    func setSearchResults(searchResults: [SearchResultsViewData])
    func setTitle(title: String?)
    var onRecursionButtonTap: ((sender: AnyObject) -> ())? { get set }
}
