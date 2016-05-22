import UIKit

final class SearchResultsViewController: BaseViewController, SearchResultsViewInput {
    private let searchResultsView = SearchResultsView()
    
    override func loadView() {
        view = searchResultsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(
//            title: "recursion".localized, // to Recursion module
//            style: .Plain,
//            target: self,
//            action: "onRecursionButtonTap:"
//        )
    }
    
    // MARK: - Private
    @objc private func onRecursionButtonTap(sender: UIBarButtonItem) {
        onRecursionButtonTap?(sender: sender)
    }
    
    // MARK: - SearchResultsViewInput
    func setSearchResults(searchResults: [SearchResultsViewData]) {
        searchResultsView.reloadWithSearchResults(searchResults)
    }
    
    @nonobjc func setTitle(title: String?) {
        self.title = title
    }
    
    var onRecursionButtonTap: ((sender: AnyObject) -> ())?
}
