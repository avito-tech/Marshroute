import Foundation

protocol AdvertisementViewInput: class, ViewLifecycleObservable {
    func setTitle(title: String?)
    func setDescription(description: String?)
    func setBackgroundRGB(rgb: (red: Double, green: Double, blue: Double)?)
    func setSimilarSearchResults(searchResults: [SearchResultsViewData])
    var onRecursionButtonTap: ((sender: AnyObject) -> ())? { get set }
}
