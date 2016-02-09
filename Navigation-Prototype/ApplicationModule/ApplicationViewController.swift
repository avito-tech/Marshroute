import UIKit

final class ApplicationViewController: UITabBarController {
	let viewOutput: ApplicationViewOutput

	//MARK: - Init
    init(viewOutput: ApplicationViewOutput) {
        self.viewOutput = viewOutput
        super.init(nibName: nil, bundle: nil)
        delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        viewOutput.viewDidRunOutOfMemory()
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
        if let index = tabBarController.viewControllers?.indexOf(viewController) where index != tabBarController.selectedIndex {
            if let tab = ApplicationTabs(rawValue: index){
                viewOutput.userDidAskTab(tab)
            }
        }
        return false
    }
}