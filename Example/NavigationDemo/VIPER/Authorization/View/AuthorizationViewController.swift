import UIKit

final class AuthorizationViewController: BaseViewController, AuthorizationViewInput {
    private let authorizationView = AuthorizationView()
    
    // MARK - Lifecycle
    override func loadView() {
        view = authorizationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "cancel".localized,
            style: .plain,
            target: self,
            action: #selector(onCancelButtonTap(_:))
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "login".localized,
            style: .done,
            target: self,
            action: #selector(onSubmitButtonTap(_:))
        )
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        authorizationView.defaultContentInsets = defaultContentInsets
    }
    
    // MARK: - Private 
    @objc private func onCancelButtonTap(_ sender: UIBarButtonItem) {
        onCancelButtonTap?()
    }
    
    @objc private func onSubmitButtonTap(_ sender: UIBarButtonItem) {
        onSubmitButtonTap?()
    }
    
    // MARK: - AuthorizationViewInput
    var onCancelButtonTap: (() -> ())?
    var onSubmitButtonTap: (() -> ())?
}
