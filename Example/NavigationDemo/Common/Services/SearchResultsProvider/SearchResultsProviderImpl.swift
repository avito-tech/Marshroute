import Foundation

private let patternAssetNames = ["aztec", "plaits", "sea", "vikings"]

final class SearchResultsProviderImpl: SearchResultsProvider {
    // MARK: - Init
    let searchResultsCacher: SearchResultsCacher
    let categoriesProvider: CategoriesProvider
    
    init(searchResultsCacher: SearchResultsCacher,
         categoriesProvider: CategoriesProvider)
    {
        self.searchResultsCacher = searchResultsCacher
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
            
            let requiresAuthorization = arc4random() % 4 == 0
            
            let patternAssetIndex = Int(arc4random() % UInt32(patternAssetNames.count))
            let patternAssetName = patternAssetNames[patternAssetIndex]
            
            let searchResult = SearchResult(
                title: title,
                id: id,
                rgb: (red, green, blue),
                requiresAuthorization: requiresAuthorization,
                patternAssetName: patternAssetName,
                placeholderAssetName: nil
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
        
        let titles_Ids_Placeholders = [
            ("🍌🍌🍌🍌🍌🍌🍌🍌🍌", "1", "bananas.jpg"),
            ("🍇🍇🍇🍇🍇🍇🍇🍇🍇", "2", "grapes.jpg"),
            ("🍏🍏🍏🍏🍏🍏🍏🍏🍏", "3", "apples.jpg"),
            ("🍒🍒🍒🍒🍒🍒🍒🍒🍒", "4", "cherries.jpg"),
            ("🍍🍍🍍🍍🍍🍍🍍🍍🍍", "5", "pineapples.jpg")
        ]
        
        let searchResults = titles_Ids_Placeholders.map { (title, id, placeholderAssetName) -> SearchResult in
            let searchResult = SearchResult(
                title: title,
                id: id,
                rgb: (white, white, white),
                requiresAuthorization: requiresAuthorization,
                patternAssetName: nil,
                placeholderAssetName: placeholderAssetName
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