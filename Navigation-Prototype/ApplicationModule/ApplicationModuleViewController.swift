import UIKit

final class ApplicationModuleViewController: UIViewController {
	var output: ApplicationModuleViewOutput?

	//MARK: - Init
    init(presenter: ApplicationModuleViewOutput) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//MARK: - ApplicationModuleViewInput
extension ApplicationModuleViewController: ApplicationModuleViewInput  {
    
}