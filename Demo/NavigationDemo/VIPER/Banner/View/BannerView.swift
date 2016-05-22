import UIKit

final class BannerView: UIView, BannerViewInput, DisposeBag, DisposeBagHolder {
    // MARK: - Init
    private let button = UIButton()
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clearColor()
        userInteractionEnabled = false
        autoresizingMask = .FlexibleWidth
        userInteractionEnabled = true
        
        addSubview(blurView)
        blurView.backgroundColor = blurView.backgroundColor?.colorWithAlphaComponent(0.5)
        blurView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        
        addSubview(button)
        button.backgroundColor = .clearColor()
        button.setTitleColor(.whiteColor(), forState: .Normal)
        button.setTitleColor(.yellowColor(), forState: .Highlighted)
        button.setTitleColor(.yellowColor(), forState: .Selected)
        button.titleLabel?.textAlignment = .Center
        button.titleLabel?.font = UIFont.systemFontOfSize(20)
        button.titleLabel?.numberOfLines = 1
        button.addTarget(self, action: "onButtonTouchDown:", forControlEvents: .TouchDown)
        button.addTarget(self, action: "onButtonTouchUpOutside:", forControlEvents: .TouchUpOutside)
        button.addTarget(self, action: "onButtonTap:", forControlEvents: .TouchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        blurView.frame = bounds
        button.frame = bounds
    }
    
    // MARK: - DisposeBagHolder
    let disposeBag: DisposeBag = DisposeBagImpl()
    
    // MARK: - BannerViewInput
    func setTitle(title: String) {
        button.setTitle(title, forState: .Normal)
    }
    
    var onTouchDown: (() -> ())?
    var onTap: (() -> ())?
    var onTouchUpOutside: (() -> ())?
    
    // MARK: - Private
    @objc private func onButtonTouchDown(sender: UIButton) {
        onTouchDown?()
    }
    
    @objc private func onButtonTouchUpOutside(sender: UIButton) {
        onTouchUpOutside?()
    }
    
    @objc private func onButtonTap(sender: UIButton) {
        onTap?()
    }
}