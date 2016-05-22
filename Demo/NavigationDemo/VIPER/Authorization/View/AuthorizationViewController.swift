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
            title: "Отмена",
            style: .Plain,
            target: self,
            action: "onCancelButtonTap:"
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Войти",
            style: .Done,
            target: self,
            action: "onSubmitButtonTap:"
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
    @objc private func onCancelButtonTap(sender: UIBarButtonItem) {
        onCancelButtonTap?()
    }
    
    @objc private func onSubmitButtonTap(sender: UIBarButtonItem) {
        onSubmitButtonTap?()
    }
    
    // MARK: - AuthorizationViewInput
    var onCancelButtonTap: (() -> ())?
    var onSubmitButtonTap: (() -> ())?
}
