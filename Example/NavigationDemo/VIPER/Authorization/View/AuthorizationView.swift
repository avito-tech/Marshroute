import UIKit

final class AuthorizationView: UIView {
    fileprivate let backgroundImage = UIImage(named: "TouchId.png")
    fileprivate let backgroundView: UIImageView?
    fileprivate let emailTextField = UITextField()
    fileprivate let passwordTextField = UITextField()
    
    // MARK: - Internal
    var defaultContentInsets: UIEdgeInsets = .zero
    
    // MARK: - Init
    init() {
        backgroundView = UIImageView(image: backgroundImage)
        
        super.init(frame: .zero)
        
        backgroundColor = .white
        backgroundView?.contentMode = .scaleAspectFit
        
        if let backgroundView = backgroundView {
            addSubview(backgroundView)
            backgroundView.contentMode = .center
        }
        
        addSubview(emailTextField)
        emailTextField.isUserInteractionEnabled = false
        emailTextField.text = "  john@appleseed.com  "
        emailTextField.backgroundColor = UIColor.red.withAlphaComponent(0.1)
        
        addSubview(passwordTextField)
        passwordTextField.isUserInteractionEnabled = false
        passwordTextField.text = "......................."
        passwordTextField.isSecureTextEntry = true
        passwordTextField.backgroundColor = UIColor.red.withAlphaComponent(0.1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let topLayoutGuide = defaultContentInsets.top
        
        let centerX = bounds.midX
        let textFieldWidth: CGFloat = 240
        
        let textFieldHeigth: CGFloat = 44
        let textFieldSpaceY: CGFloat = 10
        
        emailTextField.frame = CGRect(
            x: 0,
            y: topLayoutGuide + textFieldSpaceY,
            width: textFieldWidth,
            height: textFieldHeigth
        )
        emailTextField.center.x = centerX
        
        passwordTextField.frame = CGRect(
            x: 0,
            y: emailTextField.frame.maxY + textFieldSpaceY,
            width: textFieldWidth,
            height: textFieldHeigth
        )
        passwordTextField.center.x = centerX
        
        let backgroundViewMinY = passwordTextField.frame.maxY + 40
        
        backgroundView?.frame = CGRect(
            x: 0,
            y: backgroundViewMinY,
            width: bounds.width,
            height: bounds.maxY - backgroundViewMinY - 40
        )
    }
}
