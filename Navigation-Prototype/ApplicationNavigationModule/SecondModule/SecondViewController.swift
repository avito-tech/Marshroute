import UIKit

final class SecondViewController: UIViewController {
	var output: SecondViewOutput

    private let timerButton: UIButton
    private let dismissable: Bool
    
	//MARK: - Init
    init(presenter: SecondViewOutput, dismissable: Bool) {
        output = presenter
        self.dismissable = dismissable
        
        timerButton = UIButton(type: .Custom)
        
        super.init(nibName: nil, bundle: nil)
        
        timerButton.addTarget(self, action: "onTimerButton:", forControlEvents: [.TouchUpInside])
        timerButton.tintColor = .blueColor()
        timerButton.setTitleColor(.blackColor(), forState: .Normal)
        timerButton.titleLabel?.numberOfLines = 0
        timerButton.hidden = true
        view.addSubview(timerButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if dismissable {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "done:")
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Play, target: self, action: "next:")
        
        if dismissable || UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            timerButton.frame = CGRectMake(100, 80, 50, 40)
        } else {
            timerButton.frame = CGRectMake(400, 80, 50, 40)
        }
        
    }
    
    @objc func done(sender: UIBarButtonItem) {
        output.done()
    }
    
    @objc func next(sender: UIBarButtonItem) {
        let title = Int(self.title ?? "1") ?? 1
        output.next(sender: sender, title: title)
    }
    
    @objc func onTimerButton(sender: UIButton) {
        output.userDidRequestTimerLaunch()
    }
}

//MARK: - SecondViewInput
extension SecondViewController: SecondViewInput  {
    func setSecondsUntilTimerEnabled(cound: Int) {
        if cound == 0 {
            timerButton.setTitle("start timer", forState: .Normal)
        }
        else {
            let title = String(cound)
            timerButton.setTitle(title, forState: .Normal)
        }
    }
    
    func setTimerTurnedOn(turned: Bool) {
        timerButton.hidden = !turned
        
    }
    
    func setTimerInteractionEnabled(enabled: Bool) {
        timerButton.enabled = enabled
    }
}