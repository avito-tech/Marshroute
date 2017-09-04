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
        
        authorizationView.contentInset = { [weak self] in
            return  UIEdgeInsets(
                top: self?.topLayoutGuide.length ?? 0,
                left: 0,
                bottom: self?.bottomLayoutGuide.length ?? 0,
                right: 0
            )
        }
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
