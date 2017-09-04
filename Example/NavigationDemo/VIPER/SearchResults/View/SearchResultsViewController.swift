import UIKit

final class SearchResultsViewController: BasePeekAndPopViewController, SearchResultsViewInput {
    fileprivate let searchResultsView = SearchResultsView()
    
    override func loadView() {
        view = searchResultsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "recursion".localized, // to Recursion module
            style: .plain,
            target: self,
            action: #selector(onRecursionButtonTap(_:))
        )
    }
    
    // MARK: - Private
    @objc fileprivate func onRecursionButtonTap(_ sender: UIBarButtonItem) {
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
    override var peekSourceView: UIView {
        return searchResultsView.peekSourceView
    }
    
    override func startPeekWith(
        previewingContext: UIViewControllerPreviewing,
        location: CGPoint)
    {
        guard #available(iOS 9.0, *) 
            else { return }
        
        guard let searchResultsPeekData = searchResultsView.peekDataAt(
            location: location,
            sourceView: previewingContext.sourceView)
            else { return }
        
        previewingContext.sourceRect = searchResultsPeekData.sourceRect
        
        searchResultsPeekData.viewData.onTap()
    }
}
