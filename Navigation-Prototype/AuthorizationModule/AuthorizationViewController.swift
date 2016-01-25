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
    
}

//MARK: - AuthorizationViewInput
extension AuthorizationViewController: AuthorizationViewInput  {
    
}