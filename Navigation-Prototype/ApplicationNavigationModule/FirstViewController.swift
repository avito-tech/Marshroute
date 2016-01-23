import UIKit

final class FirstViewController: UIViewController {
	var output: FirstViewOutput
    private var buttonItems = [UIBarButtonItem]()
    
    private var toAnotherModule1Item: UIBarButtonItem?
    private var toModule2Item: UIBarButtonItem?
    private let dismissable: Bool
    private var doneButtonItem: UIBarButtonItem?

    private let timerButton: UIButton
    private let withTimer: Bool

	//MARK: - Init
    init(presenter: FirstViewOutput, dismissable: Bool, withTimer: Bool) {
        output = presenter
        self.dismissable = dismissable
        self.withTimer = withTimer
        
        timerButton = UIButton(type: .Custom)
        defer {
            timerButton.addTarget(self, action: "onTimerButton:", forControlEvents: [.TouchUpInside])
            timerButton.tintColor = .blueColor()
            timerButton.setTitleColor(.blackColor(), forState: .Normal)
            timerButton.titleLabel?.numberOfLines = 0
            timerButton.hidden = true
            view.addSubview(timerButton)
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override var title: String? {
        didSet {
            let suffix = title ?? ""
            self.navigationItem.title = "1.\(suffix)"
        }
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        if (toAnotherModule1Item == nil) {
            let toAnotherModule1Item = UIBarButtonItem(title: ">", style: .Plain, target: self, action: "onUserNextFirstModule:")
            buttonItems.append(toAnotherModule1Item)
            self.toAnotherModule1Item = toAnotherModule1Item
        }
        
        if dismissable && doneButtonItem == nil {
            let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "onDone:")
            buttonItems.append(doneButtonItem)
            self.doneButtonItem = doneButtonItem
        }
        navigationItem.rightBarButtonItems = buttonItems
        
        if withTimer || UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            timerButton.frame = CGRectMake(100, 80, 50, 40)
        } else {
            timerButton.frame = CGRectMake(400, 80, 50, 40)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onUserNextFirstModule(sender: UIBarButtonItem) {
        let index: Int
        if let title = title { index = Int(title) ?? 100500 }
        else { index = 100500 }
        
        output.onUserNextModule(index)
        navigationItem.rightBarButtonItems = buttonItems
    }
    
    @objc private func onDone(sender: UIBarButtonItem) {
        output.onUserDone()
    }
    
    @objc func onTimerButton(sender: UIButton) {
        output.userDidRequestTimerLaunch()
    }
}

//MARK: - FirstViewInput
extension FirstViewController: FirstViewInput  {
    func setSecondButtonEnabled(enabled: Bool) {
        if enabled && toModule2Item == nil {
            let toModule2Item = UIBarButtonItem(title: "to 2", style: .Plain, target: self, action: "onToModule2:")
            buttonItems.append(toModule2Item)
            self.toModule2Item = toModule2Item
            navigationItem.rightBarButtonItems = buttonItems
        }
    }
    
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
    
    @objc private func onToModule2(sender: UIBarButtonItem) {
        output.onUserSecondModule(sender: sender)
    }
}