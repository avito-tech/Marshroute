import Foundation

final class SearchResultsPresenter {
    // MARK: - Private properties
    fileprivate let interactor: SearchResultsInteractor
    fileprivate let router: SearchResultsRouter
    private let authorizationOpener: AuthorizationOpener
    
    // MARK: - Init
    init(
        interactor: SearchResultsInteractor,
        router: SearchResultsRouter,
        authorizationOpener: AuthorizationOpener)
    {
        self.interactor = interactor
        self.router = router
        self.authorizationOpener = authorizationOpener
    }
    
    // MARK: - Weak properties
    weak var view: SearchResultsViewInput? {
        didSet {
            if oldValue !== view {
                setupView()
            }
        }
    }
    
    // MARK: - Private
    fileprivate func setupView() {
        view?.onViewDidLoad = { [weak self] in
            self?.interactor.category {
                self?.interactor.categoryTitle { title in
                    self?.view?.setTitle(title)
                }
                
                self?.interactor.searchResults { searchResults in
                    if let viewSearchResults = self?.viewSearchResultsFromInteractorSearchResults(searchResults) {
                        self?.view?.setSearchResults(viewSearchResults)
                    }
                }
            }
        }
        
        view?.onRecursionButtonTap = { [weak self] sender in
            self?.router.showRecursion(sender: sender)
        }
    }
    
    fileprivate func viewSearchResultsFromInteractorSearchResults(_ searchResults: [SearchResult]) -> [SearchResultsViewData] {
        return searchResults.map { viewSearchResultFromInteractorSearchResult($0) }
    }
    
    fileprivate func viewSearchResultFromInteractorSearchResult(_ searchResult: SearchResult) -> SearchResultsViewData {
        return SearchResultsViewData(
            title: (searchResult.requiresAuthorization ? "🔒 " : "") + searchResult.title,
            rgb: searchResult.rgb,
            onTap: { [weak self] in
                self?.showAdvertisement(
                    searchResultId: searchResult.id,
                    afterAuthorization: searchResult.requiresAuthorization
                )
            }
        )
    }
    
    fileprivate func showAdvertisement(searchResultId: SearchResultId, afterAuthorization: Bool) {
        if afterAuthorization {
            authorizationOpener.openAuthorizationModule { [weak self] isAuthorized in
                if isAuthorized {
                    self?.router.showAdvertisement(searchResultId: searchResultId)
                }
            }
        } else {
            router.showAdvertisement(searchResultId: searchResultId)
        }
    }
}
