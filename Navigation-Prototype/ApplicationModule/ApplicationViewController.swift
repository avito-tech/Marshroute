import UIKit

final class ApplicationViewController: UITabBarController {
	let output: ApplicationViewOutput

	//MARK: - Init
    init(output: ApplicationViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
        delegate = self
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
    func selectTab(tab: ApplicationTabs) {
        selectedIndex = tab.rawValue
    }
}

// MARK: - UITabBarControllerDelegate
extension ApplicationViewController: UITabBarControllerDelegate {
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController)
        -> Bool
    {
        if let index = tabBarController.viewControllers?.indexOf(viewController) {
            if let tab = ApplicationTabs(rawValue: index) {
                output.userDidAskTab(tab)
            }
        }
        return false
    }
}