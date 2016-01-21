import UIKit

final class ApplicationNavigationModuleViewController: UITabBarController {
	var output: ApplicationNavigationModuleViewOutput?

	//MARK: - Init
    init(presenter: ApplicationNavigationModuleViewOutput) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//MARK: - ApplicationNavigationModuleViewInput
extension ApplicationNavigationModuleViewController: ApplicationNavigationModuleViewInput  {
    
}