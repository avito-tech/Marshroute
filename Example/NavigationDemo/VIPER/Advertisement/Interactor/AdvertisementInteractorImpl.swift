import Foundation

final class AdvertisementInteractorImpl: AdvertisementInteractor {
    // MARK: - Init
    fileprivate let advertisementId: AdvertisementId
    fileprivate let advertisementProvider: AdvertisementProvider
    
    init(advertisementId: AdvertisementId,
         advertisementProvider: AdvertisementProvider)
    {
        self.advertisementId = advertisementId
        self.advertisementProvider = advertisementProvider
    }
    
    // MARK: - Private properties
    fileprivate var advertisement: Advertisement?
    
    // MARK: - AdvertisementInteractor
    func advertisement(_ completion: () -> ()) {
        advertisement = advertisementProvider.advertisement(advertisementId: advertisementId)
        completion()
    }
    
    func advertisementTitle(_ completion: (_ title: String?) -> ()) {
        completion(advertisement?.title)
    }
    
    func advertisementPatternAssetName(_ completion: (_ assetName: String?) -> ()) {
        completion(advertisement?.patternAssetName)
    }
    
    func advertisementPlaceholderAssetName(_ completion: (_ assetName: String?) -> ()) {
        completion(advertisement?.placeholderAssetName)
    }
    
    func advertisementRGB(_ completion: (_ rgb: (red: Double, green: Double, blue: Double)?) -> ()) {
        completion(advertisement?.rgb)
    }
    
    func recommendedSearchResults(_ completion: (_ searchResults: [SearchResult]?) -> ()) {
        completion(advertisement?.recommendedSearchResults)
    }
}
