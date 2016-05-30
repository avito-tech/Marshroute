import Foundation

final class SearchResultsInteractorImpl: SearchResultsInteractor {
    // MARK: - Init
    private let categoryId: CategoryId
    private let categoriesProvider: CategoriesProvider
    private let searchResultsProvider: SearchResultsProvider
    
    // MARK: - Private propeties
    private var category: Category?
    
    init(categoryId: CategoryId,
         categoriesProvider: CategoriesProvider,
         searchResultsProvider: SearchResultsProvider)
    {
        self.categoryId = categoryId
        self.categoriesProvider = categoriesProvider
        self.searchResultsProvider = searchResultsProvider
    }
    
    // MARK: - SearchResultsInteractor
    func category(completion: () -> ()) {
        category = categoriesProvider.categoryForId(categoryId)
        completion()
    }
    
    func categoryTitle(completion: (title: String?) -> ()) {
        completion(title: category?.title)
    }
    
    func searchResults(completion: (searchResults: [SearchResult]) -> ()) {
        if let categoryId = category?.id {
            let searchResults = searchResultsProvider.searchResults(
                categoryId: categoryId,
                count: 30
            )
            completion(searchResults: searchResults)
        } else {
            completion(searchResults: [])
        }   
    }
}
