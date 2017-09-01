import UIKit
import Marshroute

final class CategoriesViewController: BasePeekAndPopViewController, CategoriesViewInput {
    fileprivate let categoriesView = CategoriesView()
    fileprivate let isDismissable: Bool
    
    // MARK: - Init
    init(
        isDismissable: Bool,
        peekAndPopUtility: PeekAndPopUtility)
    {
        self.isDismissable = isDismissable
        super.init(peekAndPopUtility: peekAndPopUtility)
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = categoriesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isDismissable {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .stop,
                target: self,
                action: #selector(onDismissButtonTap(_:))
            )
        }
    }
    
    // MARK: - BasePeekAndPopViewController
    override var peekSourceView: UIView {
        return categoriesView.peekSourceView
    }
    
    override func startPeekWith(
        previewingContext: UIViewControllerPreviewing,
        location: CGPoint)
    {
        guard #available(iOS 9.0, *) 
            else { return }
        
        guard let categoriesPeekData = categoriesView.peekDataAtLocation(
            location: location,
            sourceView: previewingContext.sourceView)
            else { return }
        
        previewingContext.sourceRect = categoriesPeekData.sourceRect
        
        categoriesPeekData.viewData.onTap()
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
