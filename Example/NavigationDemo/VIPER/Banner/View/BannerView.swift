import UIKit

final class BannerView: UIView, BannerViewInput, DisposeBag, DisposeBagHolder {
    // MARK: - Init
    private let button = UIButton()
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

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
        button.setTitleColor(.white, for: UIControl.State())
        button.setTitleColor(.yellow, for: .highlighted)
        button.setTitleColor(.yellow, for: .selected)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.titleLabel?.numberOfLines = 1
        button.addTarget(self, action: #selector(onButtonTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(onButtonTouchUpOutside(_:)), for: .touchUpOutside)
        button.addTarget(self, action: #selector(onButtonTap(_:)), for: .touchUpInside)
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
        button.setTitle(title, for: UIControl.State())
    }
    
    var onTouchDown: (() -> ())?
    var onTap: (() -> ())?
    var onTouchUpOutside: (() -> ())?
    
    // MARK: - Private
    @objc private func onButtonTouchDown(_ sender: UIButton) {
        onTouchDown?()
    }
    
    @objc private func onButtonTouchUpOutside(_ sender: UIButton) {
        onTouchUpOutside?()
    }
    
    @objc private func onButtonTap(_ sender: UIButton) {
        onTap?()
    }
}
