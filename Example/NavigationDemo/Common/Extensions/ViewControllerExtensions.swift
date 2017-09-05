import UIKit

extension UIView {
    func controlAt(location: CGPoint) -> UIControl? {
        let matchingControl = subviews.first {
            $0.frame.contains(location) 
                && $0 is UIControl
                && !$0.isHidden
                && $0.isUserInteractionEnabled
        }
        
        return matchingControl as? UIControl
    }
}
