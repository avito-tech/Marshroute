import Foundation

typealias AdvertisementId = String

struct Advertisement {
    let title: String
    let id: AdvertisementId
    let rgb: (red: Double, green: Double, blue: Double)
    let patternAssetName: String?
    let placeholderAssetName: String?
    let recommendedSearchResults: [SearchResult]
}

protocol AdvertisementProvider: AnyObject {
    func advertisement(advertisementId: AdvertisementId) -> Advertisement
}
