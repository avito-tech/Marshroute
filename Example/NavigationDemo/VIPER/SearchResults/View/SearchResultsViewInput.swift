import Foundation

struct SearchResultsViewData {
    let title: String
    let rgb: (red: Double, green: Double, blue: Double)
    let onTap: () -> ()
}

protocol SearchResultsViewInput: AnyObject, ViewLifecycleObservable {
    func setSearchResults(_ searchResults: [SearchResultsViewData])
    func setTitle(_ title: String?)
    var onRecursionButtonTap: ((_ sender: AnyObject) -> ())? { get set }
}
