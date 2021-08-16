import Foundation

protocol AdvertisementViewInput: AnyObject, ViewLifecycleObservable {
    func setTitle(_ title: String?)
    func setPatternAssetName(_ assetName: String?)
    func setPlaceholderAssetName(_ assetName: String?)
    func setBackgroundRGB(_ rgb: (red: Double, green: Double, blue: Double)?)
    func setSimilarSearchResults(_ searchResults: [SearchResultsViewData])
    func setSimilarSearchResultsHidden(_ hidden: Bool)
    var onRecursionButtonTap: ((_ sender: AnyObject) -> ())? { get set }
    var onPeek: (() -> ())? { get set }
    var onPop: (() -> ())? { get set }
}
