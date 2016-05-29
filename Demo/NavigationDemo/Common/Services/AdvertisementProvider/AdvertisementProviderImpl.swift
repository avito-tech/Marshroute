import Foundation

final class AdvertisementProviderImpl: AdvertisementProvider {
    // MARK: - Init
    let searchResultsProvider: SearchResultsProvider
    let advertisementCacher: AdvertisementCacher
    
    init(searchResultsProvider: SearchResultsProvider,
         advertisementCacher: AdvertisementCacher)
    {
        self.searchResultsProvider = searchResultsProvider
        self.advertisementCacher = advertisementCacher
    }
    
    // MARK: - AdvertisementProvider
    func advertisement(advertisementId advertisementId: AdvertisementId) -> Advertisement {
        if let advertisement = advertisementCacher.cached(advertisementId: advertisementId) {
            return advertisement
        }
        
        let searchResultId = (advertisementId as SearchResultId)
        
        let searchResult = searchResultsProvider.searchResult(
            searchResultId: searchResultId
        )
        
        let recommendedSearchResults = searchResultsProvider.recommendedSearchResults(
            searchResultId: searchResultId
        )
        
        let advertisement = Advertisement(
            title: searchResult.title,
            id: searchResult.id,
            rgb: searchResult.rgb,
            patternAssetName: searchResult.patternAssetName,
            placeholderAssetName: searchResult.placeholderAssetName,
            recommendedSearchResults: recommendedSearchResults
        )
        
        advertisementCacher.cache(advertisement: advertisement)
        
        return advertisement
    }
}