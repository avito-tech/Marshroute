import Foundation

protocol AdvertisementViewInput: class, ViewLifecycleObservable {
    func setTitle(_ title: String?)
    func setPatternAssetName(_ assetName: String?)
    func setPlaceholderAssetName(_ assetName: String?)
    func setBackgroundRGB(_ rgb: (red: Double, green: Double, blue: Double)?)
    func setSimilarSearchResults(_ searchResults: [SearchResultsViewData])
    var onRecursionButtonTap: ((_ sender: AnyObject) -> ())? { get set }
}
