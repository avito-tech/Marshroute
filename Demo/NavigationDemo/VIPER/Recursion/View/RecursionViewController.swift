import UIKit

final class RecursionViewController: BaseViewController, RecursionViewInput {
    private let recursionView = RecursionView()
    private let isDismissable: Bool
    
    // MARK: - Init
    init(isDismissable: Bool) {
        self.isDismissable = isDismissable
        super.init()
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = recursionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recursionView.contentInset = { [weak self] in
            return  UIEdgeInsets(
                top: self?.topLayoutGuide.length ?? 0,
                left: 0,
                bottom: self?.bottomLayoutGuide.length ?? 0,
                right: 0
            )
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "recursion".localized, // to Recursion module
            style: .Plain,
            target: self,
            action: #selector(RecursionViewController.onRecursionButtonTap(_:))
        )
        
        var rightBarButtonItems = [UIBarButtonItem]()
        
        if isDismissable {
            let dismissButtonItem = UIBarButtonItem(
                barButtonSystemItem: .Stop,
                target: self,
                action: #selector(RecursionViewController.onDismissButtonTap(_:))
            )
            rightBarButtonItems.append(dismissButtonItem)
        }
        
        let toCategoriesButtonItem = UIBarButtonItem(
            title: "categories".localized, // to Categories module
            style: .Plain,
            target: self,
            action: #selector(RecursionViewController.onCategoriesButtonTap(_:))
        )
        
        rightBarButtonItems.append(toCategoriesButtonItem)
        
        navigationItem.rightBarButtonItems = rightBarButtonItems
    }
    
    // MARK: - Private
    @objc private func onRecursionButtonTap(sender: UIBarButtonItem) {
        onRecursionButtonTap?(sender: sender)
    }
    
    @objc private func onCategoriesButtonTap(sender: UIBarButtonItem) {
        onCategoriesButtonTap?(sender: sender)
    }
    
    @objc private func onDismissButtonTap(sender: UIBarButtonItem) {
        onDismissButtonTap?()
    }
    
    // MARK: - RecursionViewInput
    @nonobjc func setTitle(title: String?) {
        self.title = title
    }
    
    func setTimerButtonVisible(visible: Bool) {
        recursionView.setTimerButtonVisible(visible)
    }
    
    func setTimerButtonEnabled(enabled: Bool) {
        recursionView.setTimerButtonEnabled(enabled)
    }
    
    func setTimerButtonTitle(title: String) {
        recursionView.setTimerButtonTitle(title)
    }
    
    var onRecursionButtonTap: ((sender: AnyObject) -> ())?
    
    var onDismissButtonTap: (() -> ())?
    
    var onCategoriesButtonTap: ((sender: AnyObject) -> ())?
    
    var onTimerButtonTap: (() -> ())? {
        get { return recursionView.onTimerButtonTap }
        set { recursionView.onTimerButtonTap = newValue }
    }
}