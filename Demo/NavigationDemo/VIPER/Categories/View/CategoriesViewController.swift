import UIKit

final class CategoriesViewController: BaseViewController, CategoriesViewInput {
    private let categoriesView = CategoriesView()
    private let isDismissable: Bool
    
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
                barButtonSystemItem: .Stop,
                target: self,
                action: "onDismissButtonTap:"
            )
        }
    }
    
    // MARK: - Private
    @objc private func onDismissButtonTap(sender: UIBarButtonItem) {
        onDismissButtonTap?()
    }
   
    // MARK: - CategoriesViewInput
    func setCategories(categories: [CategoriesViewData]) {
        categoriesView.reloadWithCategories(categories)
    }
    
    @nonobjc func setTitle(title: String?) {
        self.navigationItem.title = title
    }
    
    func setTimerButtonVisible(visible: Bool) {
        categoriesView.setTimerButtonVisible(visible)
    }
    
    func setTimerButtonEnabled(enabled: Bool) {
        categoriesView.setTimerButtonEnabled(enabled)
    }
    
    func setTimerButtonTitle(title: String) {
        categoriesView.setTimerButtonTitle(title)
    }
    
    var onDismissButtonTap: (() -> ())?
    
    var onTimerButtonTap: (() -> ())? {
        get { return categoriesView.onTimerButtonTap }
        set { categoriesView.onTimerButtonTap = newValue }
    }
}
