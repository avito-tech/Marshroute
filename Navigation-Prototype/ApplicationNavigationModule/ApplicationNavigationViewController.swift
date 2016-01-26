import UIKit

final class ApplicationNavigationViewController: UITabBarController {
	let output: ApplicationNavigationViewOutput

	//MARK: - Init
    init(output: ApplicationNavigationViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//MARK: - ApplicationNavigationViewInput
extension ApplicationNavigationViewController: ApplicationNavigationViewInput  {
    
}