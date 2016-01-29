import UIKit

final class ApplicationViewController: UITabBarController {
	let output: ApplicationViewOutput

	//MARK: - Init
    init(output: ApplicationViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        output.userDidRunOutOfMemory()
    }
}

//MARK: - ApplicationViewInput
extension ApplicationViewController: ApplicationViewInput  {
    
}