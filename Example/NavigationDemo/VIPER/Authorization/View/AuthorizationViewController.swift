import UIKit

final class AuthorizationViewController: BaseViewController, AuthorizationViewInput {
    fileprivate let authorizationView = AuthorizationView()
    
    // MARK - Lifecycle
    override func loadView() {
        view = authorizationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Отмена",
            style: .plain,
            target: self,
            action: #selector(onCancelButtonTap(_:))
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Войти",
            style: .done,
            target: self,
            action: #selector(onSubmitButtonTap(_:))
        )
    }
    
    override func viewWillLayoutSubviews() {
        super .viewWillLayoutSubviews()
        
        authorizationView.defaultContentInsets = defaultContentInsets
    }
    
    // MARK: - Private 
    @objc fileprivate func onCancelButtonTap(_ sender: UIBarButtonItem) {
        onCancelButtonTap?()
    }
    
    @objc fileprivate func onSubmitButtonTap(_ sender: UIBarButtonItem) {
        onSubmitButtonTap?()
    }
    
    // MARK: - AuthorizationViewInput
    var onCancelButtonTap: (() -> ())?
    var onSubmitButtonTap: (() -> ())?
}
