import UIKit
import Marshroute

final class AdvertisementViewController: BasePeekAndPopViewController, AdvertisementViewInput {
    // MARK: - Private properties
    fileprivate let advertisementView = AdvertisementView()
    private let peekAndPopStateViewControllerObservable: PeekAndPopStateViewControllerObservable
    
    // MARK: - Init
    init(
        peekAndPopStateViewControllerObservable: PeekAndPopStateViewControllerObservable,
        peekAndPopUtility: PeekAndPopUtility) 
    {
        self.peekAndPopStateViewControllerObservable = peekAndPopStateViewControllerObservable
        
        super.init(peekAndPopUtility: peekAndPopUtility)
        
        subscribeForPeekAndPopStateChanges()
    }
    
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
        
        advertisementView.defaultContentInsets = defaultContentInsets
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
    
    private func subscribeForPeekAndPopStateChanges() {
        peekAndPopStateViewControllerObservable.addObserver(
            disposableViewController: self,
            onPeekAndPopStateChange: { [weak self] peekAndPopState in
                switch peekAndPopState {
                case .inPeek:
                    self?.onPeek?()
                case .popped:
                    self?.onPop?()
                case .interrupted:
                    break
                }
            }
        )
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
    
    func setSimilarSearchResultsHidden(_ hidden: Bool) {
        advertisementView.setSimilarSearchResultsHidden(hidden)
    }
    
    var onRecursionButtonTap: ((_ sender: AnyObject) -> ())?
    
    var onPeek: (() -> ())?
    
    var onPop: (() -> ())?
}
