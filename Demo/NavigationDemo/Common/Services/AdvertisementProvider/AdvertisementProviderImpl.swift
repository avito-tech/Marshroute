import Foundation

final class AdvertisementProviderImpl: AdvertisementProvider {
    // MARK: - Init
    let searchResultsProvider: SearchResultsProvider
    let advertisementCacher: AdvertisementCacher
    let randomStringGenerator: RandomStringGenerator
    
    init(searchResultsProvider: SearchResultsProvider,
         advertisementCacher: AdvertisementCacher,
         randomStringGenerator: RandomStringGenerator)
    {
        self.searchResultsProvider = searchResultsProvider
        self.advertisementCacher = advertisementCacher
        self.randomStringGenerator = randomStringGenerator
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
        
        let description = randomStringGenerator.randomTextStartingWith(searchResult.title)
        
        let recommendedSearchResults = searchResultsProvider.recommendedSearchResults(
            searchResultId: searchResultId
        )
        
        let advertisement = Advertisement(
            title: searchResult.title,
            id: searchResult.id,
            rgb: searchResult.rgb,
            description: description,
            recommendedSearchResults: recommendedSearchResults
        )
        
        advertisementCacher.cache(advertisement: advertisement)
        
        return advertisement
    }
}
