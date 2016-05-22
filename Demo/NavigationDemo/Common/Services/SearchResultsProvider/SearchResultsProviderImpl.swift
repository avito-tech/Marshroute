import Foundation

final class SearchResultsProviderImpl: SearchResultsProvider {
    // MARK: - Init
    let searchResultsCacher: SearchResultsCacher
    let randomStringGenerator: RandomStringGenerator
    let categoriesProvider: CategoriesProvider
    
    init(searchResultsCacher: SearchResultsCacher,
         randomStringGenerator: RandomStringGenerator,
         categoriesProvider: CategoriesProvider)
    {
        self.searchResultsCacher = searchResultsCacher
        self.randomStringGenerator = randomStringGenerator
        self.categoriesProvider = categoriesProvider
    }
    
    // MARK: - SearchResultsProvider
    func searchResults(categoryId categoryId: CategoryId, count: Int) -> [SearchResult]
    {
        let category = categoriesProvider.categoryForId(categoryId)
        
        var searchResults = [SearchResult]()
        
        for i in 0 ..< count {
            let red = Double(arc4random() % 255) / 255.0
            let green = Double(arc4random() % 255) / 255.0
            let blue = Double(arc4random() % 255) / 255.0
            
            let title = category.title + " \(i)"
            
            let id = NSUUID().UUIDString
            
            let requiresAuthorization = arc4random() % 5 == 0
            
            let searchResult = SearchResult(
                title: title,
                id: id,
                rgb: (red, green, blue),
                requiresAuthorization: false//requiresAuthorization
            )
            
            searchResults.append(searchResult)
            
            searchResultsCacher.cache(searchResult: searchResult)
        }
        
        return searchResults
    }
    
    func searchResult(searchResultId searchResultId: SearchResultId) -> SearchResult {
        return searchResultsCacher.cached(searchResultId: searchResultId)!
    }
    
    func recommendedSearchResults(searchResultId searchResultId: SearchResultId) -> [SearchResult] {
        
        let white: Double = 255
        let requiresAuthorization = false
        
        let titlesToIds = [
            "🍌🍌🍌🍌🍌🍌🍌🍌🍌" : "bananas",
            "🍇🍇🍇🍇🍇🍇🍇🍇🍇" : "grapes",
            "🍏🍏🍏🍏🍏🍏🍏🍏🍏" : "apples",
            "🍒🍒🍒🍒🍒🍒🍒🍒🍒" : "cherries",
            "🍍🍍🍍🍍🍍🍍🍍🍍🍍" : "pineapples"
            ]
        
        let searchResults = titlesToIds.map { (title, id) -> SearchResult in
            let searchResult = SearchResult(
                title: title,
                id: id,
                rgb: (white, white, white),
                requiresAuthorization: requiresAuthorization
            )
            
            searchResultsCacher.cache(searchResult: searchResult)
            
            return searchResult
        }
        
        // Leave only 4 items
        var filteredSearchResults = searchResults.filter { $0.id != searchResultId }
        if filteredSearchResults.count == searchResults.count {
            // Even if recommended search results were requested for a search result id
            // different from recommended search result ids
            filteredSearchResults.removeFirst()
        }
        return filteredSearchResults
    }
}