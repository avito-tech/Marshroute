import Foundation

final class AdvertisementInteractorImpl: AdvertisementInteractor {
    // MARK: - Init
    private let advertisementId: AdvertisementId
    private let advertisementProvider: AdvertisementProvider
    
    init(advertisementId: AdvertisementId,
         advertisementProvider: AdvertisementProvider)
    {
        self.advertisementId = advertisementId
        self.advertisementProvider = advertisementProvider
    }
    
    // MARK: - Private properties
    private var advertisement: Advertisement?
    
    // MARK: - AdvertisementInteractor
    func advertisement(completion: () -> ()) {
        advertisement = advertisementProvider.advertisement(advertisementId: advertisementId)
        completion()
    }
    
    func advertisementTitle(completion: (title: String?) -> ()) {
        completion(title: advertisement?.title)
    }
    
    func advertisementPatternAssetName(completion: (assetName: String?) -> ()) {
        completion(assetName: advertisement?.patternAssetName)
    }
    
    func advertisementPlaceholderAssetName(completion: (assetName: String?) -> ()) {
        completion(assetName: advertisement?.placeholderAssetName)
    }
    
    func advertisementRGB(completion:(rgb: (red: Double, green: Double, blue: Double)?) -> ()) {
        completion(rgb: advertisement?.rgb)
    }
    
    func recommendedSearchResults(completion: (searchResults: [SearchResult]?) -> ()) {
        completion(searchResults: advertisement?.recommendedSearchResults)
    }
}