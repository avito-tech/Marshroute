import UIKit

final class AdvertisementViewController: BasePeekAndPopViewController, AdvertisementViewInput {
    fileprivate let advertisementView = AdvertisementView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = advertisementView
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let uiInsets = UIEdgeInsets(
            top: topLayoutGuide.length ,
            left: 0,
            bottom: bottomLayoutGuide.length,
            right: 0
        )
        
        advertisementView.setUIInsets(uiInsets)
    }
    
    // MARK: - BasePeekAndPopViewController
    override var peekSourceViews: [UIView] {
        return advertisementView.peekSourceViews + [navigationController?.navigationBar].flatMap { $0 }
    }
    
    @available(iOS 9.0, *)
    override func startPeekWith(
        previewingContext: UIViewControllerPreviewing,
        location: CGPoint)
    {
        if advertisementView.peekSourceViews.contains(previewingContext.sourceView) {
            if let peekData = advertisementView.peekDataAt(
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
    
    // MARK: - Private
    @objc fileprivate func onRecursionButtonTap(_ sender: UIBarButtonItem) {
        onRecursionButtonTap?(sender)
    }
    
    // MARK: - AdvertisementViewInput
    @nonobjc func setTitle(_ title: String?) {
        self.title = title
    }
    
    func setPatternAssetName(_ assetName: String?) {
        advertisementView.setPatternAssetName(assetName)
    }

    func setPlaceholderAssetName(_ assetName: String?) {
        advertisementView.setPlaceholderAssetName(assetName)
    }
    
    func setBackgroundRGB(_ rgb: (red: Double, green: Double, blue: Double)?) {
        advertisementView.setBackgroundRGB(rgb)
    }
    
    func setSimilarSearchResults(_ searchResults: [SearchResultsViewData]) {
        advertisementView.setSimilarSearchResults(searchResults)
    }
    
    var onRecursionButtonTap: ((_ sender: AnyObject) -> ())?
}
