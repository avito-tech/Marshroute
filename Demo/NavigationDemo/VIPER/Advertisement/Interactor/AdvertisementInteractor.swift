import Foundation

protocol AdvertisementInteractor: class {
    func advertisement(completion: () -> ())
    func advertisementTitle(completion: (title: String?) -> ())
    func advertisementPatternAssetName(completion: (assetName: String?) -> ())
    func advertisementPlaceholderAssetName(completion: (assetName: String?) -> ())
    func advertisementRGB(completion:(rgb: (red: Double, green: Double, blue: Double)?) -> ())
    func recommendedSearchResults(completion: (searchResults: [SearchResult]?) -> ())
}