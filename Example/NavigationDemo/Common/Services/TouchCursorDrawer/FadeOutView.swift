import UIKit

final class FadeOutView: UIView {
    // MARK: - Init
    init() {
        let frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        super.init(frame: frame)
        
        self.backgroundColor = .clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Drawing
    override func drawRect(rect: CGRect) {
        // Red circle
        let context = UIGraphicsGetCurrentContext()
        CGContextAddEllipseInRect(context, rect)
        CGContextSetFillColor(context, CGColorGetComponents (UIColor.redColor().CGColor))
        CGContextFillPath(context)
    }
    
    // MARK: - Interval
    func fadeOut() {
        UIView.animateWithDuration(
            0.25,
            animations: {
                self.alpha = 0
                self.transform = CGAffineTransformMakeScale(0.00001, 0.00001)
            },
            completion: { _ in
                self.removeFromSuperview()
            }
        )
    }
}
