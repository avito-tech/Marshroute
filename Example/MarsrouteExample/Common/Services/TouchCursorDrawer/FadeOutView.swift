import UIKit

final class FadeOutView: UIView {
    // MARK: - Init
    init() {
        let frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Drawing
    override func draw(_ rect: CGRect) {
        // Red circle
        let context = UIGraphicsGetCurrentContext()
        context?.addEllipse(in: rect)
        context?.setFillColor(UIColor.red.cgColor.components! )
        context?.fillPath()
    }
    
    // MARK: - Interval
    func fadeOut() {
        UIView.animate(
            withDuration: 0.25,
            animations: {
                self.alpha = 0
                self.transform = CGAffineTransform(scaleX: 0.000_01, y: 0.000_01)
            },
            completion: { _ in
                self.removeFromSuperview()
            }
        )
    }
}
