import Foundation

protocol AdvertisementViewInput: class, ViewLifecycleObservable {
    func setTitle(title: String?)
    func setPatternAssetName(assetName: String?)
    func setPlaceholderAssetName(assetName: String?)
    func setBackgroundRGB(rgb: (red: Double, green: Double, blue: Double)?)
    func setSimilarSearchResults(searchResults: [SearchResultsViewData])
    var onRecursionButtonTap: ((sender: AnyObject) -> ())? { get set }
}
