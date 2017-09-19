import UIKit
import Marshroute

final class CategoriesViewController: BasePeekAndPopViewController, CategoriesViewInput {
    fileprivate let categoriesView = CategoriesView()
    fileprivate let viewControllerPosition: ViewControllerPosition
    
    // MARK: - Init
    init(
        viewControllerPosition: ViewControllerPosition,
        peekAndPopUtility: PeekAndPopUtility)
    {
        self.viewControllerPosition = viewControllerPosition
        super.init(peekAndPopUtility: peekAndPopUtility)
        automaticallyAdjustsScrollViewInsets = true
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = categoriesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if viewControllerPosition == .modal {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .stop,
                target: self,
                action: #selector(onDismissButtonTap(_:))
            )
        }
    }
    
    // MARK: - BasePeekAndPopViewController
    override var peekSourceViews: [UIView] {
        return categoriesView.peekSourceViews
    }
    
    @available(iOS 9.0, *)
    override func startPeekWith(
        previewingContext: UIViewControllerPreviewing,
        location: CGPoint)
    {
        guard let peekData = categoriesView.peekDataAt(
            location: location,
            sourceView: previewingContext.sourceView)
            else { return }
        
        previewingContext.sourceRect = peekData.sourceRect
        
        peekData.viewData.onTap()
    }
    
    // MARK: - Private
    @objc fileprivate func onDismissButtonTap(_ sender: UIBarButtonItem) {
        onDismissButtonTap?()
    }
   
    // MARK: - CategoriesViewInput
    func setCategories(_ categories: [CategoriesViewData]) {
        categoriesView.reloadWithCategories(categories)
    }
    
    @nonobjc func setTitle(_ title: String?) {
        self.navigationItem.title = title
    }
    
    func setTimerButtonVisible(_ visible: Bool) {
        categoriesView.setTimerButtonVisible(visible)
    }
    
    func setTimerButtonEnabled(_ enabled: Bool) {
        categoriesView.setTimerButtonEnabled(enabled)
    }
    
    func setTimerButtonTitle(_ title: String) {
        categoriesView.setTimerButtonTitle(title)
    }
    
    var onDismissButtonTap: (() -> ())?
    
    var onTimerButtonTap: (() -> ())? {
        get { return categoriesView.onTimerButtonTap }
        set { categoriesView.onTimerButtonTap = newValue }
    }
}
