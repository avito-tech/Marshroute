import UIKit

final class FirstViewController: UIViewController {
	var output: FirstViewOutput?

	//MARK: - Init
    init(presenter: FirstViewOutput) {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: ">", style: .Plain, target: self, action: "gogogo:")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func gogogo(sender: UIBarButtonItem) {
        let index: Int
        if let title = title { index = Int(title) ?? 100500 }
        else { index = 100500 }
        
        output?.gogogo(index)
    }
    
}

//MARK: - FirstViewInput
extension FirstViewController: FirstViewInput  {
    
}