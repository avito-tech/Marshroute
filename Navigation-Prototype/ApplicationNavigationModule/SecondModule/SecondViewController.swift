import UIKit

final class SecondViewController: UIViewController {
	var output: SecondViewOutput

	//MARK: - Init
    init(presenter: SecondViewOutput) {
        output = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "done:")
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Play, target: self, action: "next:")
    }
    
    @objc func done(sender: UIBarButtonItem) {
        output.done()
    }
    
    @objc func next(sender: UIBarButtonItem) {
        let title = Int(self.title ?? "1") ?? 1
        output.next(sender: sender, title: title)
    }
}

//MARK: - SecondViewInput
extension SecondViewController: SecondViewInput  {
    
}