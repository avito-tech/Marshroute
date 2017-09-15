import UIKit

final class RecursionView: UIView {
    fileprivate let backgroundImageView = UIImageView(image: UIImage(named: "Recursion.jpg"))
    fileprivate let timerButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    var contentInset: (() -> (UIEdgeInsets))?
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        addSubview(backgroundImageView)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.layer.masksToBounds = true
        
        addSubview(timerButton)
        timerButton.setTitleColor(.white, for: UIControlState())
        timerButton.backgroundColor = .blue
        timerButton.addTarget(self, action: #selector(onTimerButtonTap(_:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        backgroundImageView.frame = bounds
        
        let contentInset = self.contentInset?() ?? UIEdgeInsets.zero
        timerButton.frame = CGRect(x: 0, y: contentInset.top, width: bounds.width, height: 30)
    }
    
    // MARK: - Internal
    func setTimerButtonVisible(_ visible: Bool) {
        timerButton.isHidden = !visible
    }
    
    func setTimerButtonEnabled(_ enabled: Bool) {
        timerButton.isEnabled = enabled
    }
    
    func setTimerButtonTitle(_ title: String) {
        timerButton.setTitle(title, for: UIControlState())
    }
    
    var onTimerButtonTap: (() -> ())?

    // MARK: - Private
    @objc fileprivate func onTimerButtonTap(_ sender: UIButton) {
        onTimerButtonTap?()
    }
}
