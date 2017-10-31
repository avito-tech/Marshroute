import UIKit

final class SearchResultsViewController: BasePeekAndPopViewController, SearchResultsViewInput {
    private let searchResultsView = SearchResultsView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = searchResultsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "recursion".localized, // to Recursion module
            style: .plain,
            target: self,
            action: #selector(onRecursionButtonTap(_:))
        )
    }
    
    // MARK: - Private
    @objc private func onRecursionButtonTap(_ sender: UIBarButtonItem) {
        onRecursionButtonTap?(sender)
    }
    
    // MARK: - SearchResultsViewInput
    func setSearchResults(_ searchResults: [SearchResultsViewData]) {
        searchResultsView.reloadWithSearchResults(searchResults)
    }
    
    @nonobjc func setTitle(_ title: String?) {
        self.title = title
    }
    
    var onRecursionButtonTap: ((_ sender: AnyObject) -> ())?
    
    // MARK: - BasePeekAndPopViewController
    override var peekSourceViews: [UIView] {
        return searchResultsView.peekSourceViews + [navigationController?.navigationBar].flatMap { $0 }
    }
    
    @available(iOS 9.0, *)
    override func startPeekWith(
        previewingContext: UIViewControllerPreviewing,
        location: CGPoint)
    {
        if searchResultsView.peekSourceViews.contains(previewingContext.sourceView) {
            if let peekData = searchResultsView.peekDataAt(
                location: location,
                sourceView: previewingContext.sourceView) 
            {
                previewingContext.sourceRect = peekData.sourceRect
                peekData.viewData.onTap()
            } 
        } else {
            super.startPeekWith(
                previewingContext: previewingContext,
                location: location
            )
        }            
    }
}
