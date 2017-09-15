import Foundation

protocol AdvertisementInteractor: class {
    func advertisement(_ completion: () -> ())
    func advertisementTitle(_ completion: (_ title: String?) -> ())
    func advertisementPatternAssetName(_ completion: (_ assetName: String?) -> ())
    func advertisementPlaceholderAssetName(_ completion: (_ assetName: String?) -> ())
    func advertisementRGB(_ completion: (_ rgb: (red: Double, green: Double, blue: Double)?) -> ())
    func recommendedSearchResults(_ completion: (_ searchResults: [SearchResult]?) -> ())
}
