import UIKit

final class AuthorizationView: UIView {
    private let backgroundImage = UIImage(named: "TouchId.png")
    private let backgroundView: UIImageView?
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    var contentInset: (() -> (UIEdgeInsets))?
    
    // MARK: - Init
    init() {
        backgroundView = UIImageView(image: backgroundImage)
        
        super.init(frame: .zero)
        
        backgroundColor = .whiteColor()
        backgroundView?.contentMode = .ScaleAspectFit
        
        if let backgroundView = backgroundView {
            addSubview(backgroundView)
            backgroundView.contentMode = .Center
        }
        
        addSubview(emailTextField)
        emailTextField.userInteractionEnabled = false
        emailTextField.text = "  john@appleseed.com  "
        emailTextField.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.1)
        
        addSubview(passwordTextField)
        passwordTextField.userInteractionEnabled = false
        passwordTextField.text = "......................."
        passwordTextField.secureTextEntry = true
        passwordTextField.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let topLayoutGuide = contentInset?().top ?? 64
        
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