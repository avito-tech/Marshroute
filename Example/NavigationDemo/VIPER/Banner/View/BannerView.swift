import UIKit

final class BannerView: UIView, BannerViewInput, DisposeBag, DisposeBagHolder {
    // MARK: - Init
    fileprivate let button = UIButton()
    fileprivate let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        isUserInteractionEnabled = false
        autoresizingMask = .flexibleWidth
        isUserInteractionEnabled = true
        
        addSubview(blurView)
        blurView.backgroundColor = blurView.backgroundColor?.withAlphaComponent(0.5)
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        addSubview(button)
        button.backgroundColor = .clear
        button.setTitleColor(.white, for: UIControlState())
        button.setTitleColor(.yellow, for: .highlighted)
        button.setTitleColor(.yellow, for: .selected)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.titleLabel?.numberOfLines = 1
        button.addTarget(self, action: #selector(BannerView.onButtonTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(BannerView.onButtonTouchUpOutside(_:)), for: .touchUpOutside)
        button.addTarget(self, action: #selector(BannerView.onButtonTap(_:)), for: .touchUpInside)
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
    func setTitle(_ title: String) {
        button.setTitle(title, for: UIControlState())
    }
    
    var onTouchDown: (() -> ())?
    var onTap: (() -> ())?
    var onTouchUpOutside: (() -> ())?
    
    // MARK: - Private
    @objc fileprivate func onButtonTouchDown(_ sender: UIButton) {
        onTouchDown?()
    }
    
    @objc fileprivate func onButtonTouchUpOutside(_ sender: UIButton) {
        onTouchUpOutside?()
    }
    
    @objc fileprivate func onButtonTap(_ sender: UIButton) {
        onTap?()
    }
}
