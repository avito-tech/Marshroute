import UIKit

final class CategoriesViewController: BaseViewController, CategoriesViewInput {
    fileprivate let categoriesView = CategoriesView()
    fileprivate let isDismissable: Bool
    
    // MARK: - Init
    init(isDismissable: Bool) {
        self.isDismissable = isDismissable
        super.init()
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
                action: #selector(CategoriesViewController.onDismissButtonTap(_:))
            )
        }
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
