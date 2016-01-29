import UIKit

final class AuthorizationViewController: UIViewController {
	var output: AuthorizationViewOutput?

	//MARK: - Init
    init(output: AuthorizationViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "onCancel:")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "onDone:")
    }

    @objc func onCancel(sender: UIBarButtonItem) {
        output?.userDidCancel()
    }
    
    @objc func onDone(sender: UIBarButtonItem) {
        output?.userDidAuth()
    }
}

//MARK: - AuthorizationViewInput
extension AuthorizationViewController: AuthorizationViewInput  {
    
}