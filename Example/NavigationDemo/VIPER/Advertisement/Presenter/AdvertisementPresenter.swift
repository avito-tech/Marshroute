import Foundation

final class AdvertisementPresenter {
    // MARK: - Init
    fileprivate let interactor: AdvertisementInteractor
    fileprivate let router: AdvertisementRouter
    
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
    fileprivate func setupView() {
        view?.onViewDidLoad = { [weak self] in
            self?.interactor.advertisement {
                self?.interactor.advertisementTitle { title in
                    self?.view?.setTitle(title)
                }
                
                self?.interactor.advertisementPatternAssetName { assetName in
                    self?.view?.setPatternAssetName(assetName)
                }
                
                self?.interactor.advertisementPlaceholderAssetName { assetName in
                    self?.view?.setPlaceholderAssetName(assetName)
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
            self?.router.showRecursion(sender: sender)
        }
        
        view?.onPeekStateChange = { [weak self] isInPeekState in
            self?.view?.setSimilarSearchResultsHidden(isInPeekState)
        }
    }
    
    fileprivate func viewSearchResultsFromInteractorSearchResults(_ searchResults: [SearchResult]) -> [SearchResultsViewData] {
        return searchResults.map { viewSearchResultFromInteractorSearchResult($0) }
    }
    
    fileprivate func viewSearchResultFromInteractorSearchResult(_ searchResult: SearchResult) -> SearchResultsViewData {
        return SearchResultsViewData(
            title: searchResult.title,
            rgb: searchResult.rgb,
            onTap: { [weak self] in
                self?.router.showSimilarSearchResult(searchResultId: searchResult.id)
            }
        )
    }
}
