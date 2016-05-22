import UIKit

final class RecursionView: UIView {
    private let backgroundImageView = UIImageView(image: UIImage(named: "Recursion.jpg"))
    private var timerButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    var contentInset: (() -> (UIEdgeInsets))?
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        addSubview(backgroundImageView)
        backgroundImageView.contentMode = .ScaleAspectFill
        backgroundImageView.layer.masksToBounds = true
        
        addSubview(timerButton)
        timerButton.setTitleColor(.whiteColor(), forState: .Normal)
        timerButton.backgroundColor = .blueColor()
        timerButton.addTarget(self, action: "onTimerButtonTap:", forControlEvents: .TouchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        backgroundImageView.frame = bounds
        
        let contentInset = self.contentInset?() ?? UIEdgeInsetsZero
        timerButton.frame = CGRect(x: 0, y: contentInset.top, width: bounds.width, height: 30)
    }
    
    // MARK: - Internal
    func setTimerButtonVisible(visible: Bool) {
        timerButton.hidden = !visible
    }
    
    func setTimerButtonEnabled(enabled: Bool) {
        timerButton.enabled = enabled
    }
    
    func setTimerButtonTitle(title: String) {
        timerButton.setTitle(title, forState: .Normal)
    }
    
    var onTimerButtonTap: (() -> ())?

    // MARK: - Private
    @objc private func onTimerButtonTap(sender: UIButton) {
        onTimerButtonTap?()
    }
}