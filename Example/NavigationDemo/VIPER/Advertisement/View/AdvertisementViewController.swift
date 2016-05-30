import UIKit

final class AdvertisementViewController: BaseViewController, AdvertisementViewInput {
    private let advertisementView = AdvertisementView()
    
    override func loadView() {
        view = advertisementView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "recursion".localized, // to Recursion module
            style: .Plain,
            target: self,
            action: #selector(AdvertisementViewController.onRecursionButtonTap(_:))
        )
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let uiInsets = UIEdgeInsets(
            top: topLayoutGuide.length ?? 0,
            left: 0,
            bottom: bottomLayoutGuide.length ?? 0,
            right: 0
        )
        
        advertisementView.setUIInsets(uiInsets)
    }
    
    // MARK: - Private
    @objc private func onRecursionButtonTap(sender: UIBarButtonItem) {
        onRecursionButtonTap?(sender: sender)
    }
    
    // MARK: - AdvertisementViewInput
    @nonobjc func setTitle(title: String?) {
        self.title = title
    }
    
    func setPatternAssetName(assetName: String?) {
        advertisementView.setPatternAssetName(assetName)
    }

    func setPlaceholderAssetName(assetName: String?) {
        advertisementView.setPlaceholderAssetName(assetName)
    }
    
    func setBackgroundRGB(rgb: (red: Double, green: Double, blue: Double)?) {
        advertisementView.setBackgroundRGB(rgb)
    }
    
    func setSimilarSearchResults(searchResults: [SearchResultsViewData]) {
        advertisementView.setSimilarSearchResults(searchResults)
    }
    
    var onRecursionButtonTap: ((sender: AnyObject) -> ())?
}
