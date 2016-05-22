import Foundation

final class AdvertisementPresenter {
    // MARK: - Init
    private let interactor: AdvertisementInteractor
    private let router: AdvertisementRouter
    
    init(interactor: AdvertisementInteractor, router: AdvertisementRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Weak properties
    weak var view: AdvertisementViewInput? {
        didSet {
            setupView()
        }
    }
    
    // MARK: - Private
    private func setupView() {
        view?.onViewDidLoad = { [weak self] in
            self?.interactor.advertisement {
                self?.interactor.advertisementTitle { title in
                    self?.view?.setTitle(title)
                }

                self?.interactor.advertisementDescription { description in
                    self?.view?.setDescription(description)
                }
                
                self?.interactor.advertisementRGB { rgb in
                    self?.view?.setBackgroundRGB(rgb)
                }
                
                self?.interactor.recommendedSearchResults { searchResults in
                    if let searchResults = searchResults {
                        if let viewSimilarSearchResults = self?.viewSearchResultsFromInteractorSearchResults(searchResults) {
                            self?.view?.setSimilarSearchResults(viewSimilarSearchResults)
                        }
                    }
                }
            }
        }
        
        view?.onRecursionButtonTap = { [weak self] sender in
            self?.router.showRecursion(sender)
        }
    }
    
    private func viewSearchResultsFromInteractorSearchResults(searchResults: [SearchResult]) -> [SearchResultsViewData] {
        return searchResults.map { viewSearchResultFromInteractorSearchResult($0) }
    }
    
    private func viewSearchResultFromInteractorSearchResult(searchResult: SearchResult) -> SearchResultsViewData {
        return SearchResultsViewData(
            title: searchResult.title,
            rgb: searchResult.rgb,
            onTap: { [weak self] in
                self?.router.showSimilarSearchResult(searchResultId: searchResult.id)
            }
        )
    }
}
