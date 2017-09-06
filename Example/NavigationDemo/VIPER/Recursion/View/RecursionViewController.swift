import UIKit
import Marshroute

final class RecursionViewController: BasePeekAndPopViewController, RecursionViewInput {
    fileprivate let recursionView = RecursionView()
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
            style: .plain,
            target: self,
            action: #selector(onRecursionButtonTap(_:))
        )
        
        var rightBarButtonItems = [UIBarButtonItem]()
        
        if isDismissable {
            let dismissButtonItem = UIBarButtonItem(
                barButtonSystemItem: .stop,
                target: self,
                action: #selector(onDismissButtonTap(_:))
            )
            rightBarButtonItems.append(dismissButtonItem)
        }
        
        let toCategoriesButtonItem = UIBarButtonItem(
            title: "categories".localized, // to Categories module
            style: .plain,
            target: self,
            action: #selector(onCategoriesButtonTap(_:))
        )
        
        rightBarButtonItems.append(toCategoriesButtonItem)
        
        navigationItem.rightBarButtonItems = rightBarButtonItems
    }
    
    // MARK: - BasePeekAndPopViewController
    override var peekSourceViews: [UIView] {
        return [navigationController?.navigationBar].flatMap { $0 }
    }
    
    // MARK: - Private
    @objc fileprivate func onRecursionButtonTap(_ sender: UIBarButtonItem) {
        onRecursionButtonTap?(sender)
    }
    
    @objc fileprivate func onCategoriesButtonTap(_ sender: UIBarButtonItem) {
        onCategoriesButtonTap?(sender)
    }
    
    @objc fileprivate func onDismissButtonTap(_ sender: UIBarButtonItem) {
        onDismissButtonTap?()
    }
    
    // MARK: - RecursionViewInput
    @nonobjc func setTitle(_ title: String?) {
        self.title = title
    }
    
    func setTimerButtonVisible(_ visible: Bool) {
        recursionView.setTimerButtonVisible(visible)
    }
    
    func setTimerButtonEnabled(_ enabled: Bool) {
        recursionView.setTimerButtonEnabled(enabled)
    }
    
    func setTimerButtonTitle(_ title: String) {
        recursionView.setTimerButtonTitle(title)
    }
    
    var onRecursionButtonTap: ((_ sender: AnyObject) -> ())?
    
    var onDismissButtonTap: (() -> ())?
    
    var onCategoriesButtonTap: ((_ sender: AnyObject) -> ())?
    
    var onTimerButtonTap: (() -> ())? {
        get { return recursionView.onTimerButtonTap }
        set { recursionView.onTimerButtonTap = newValue }
    }
}
