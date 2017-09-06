import UIKit

extension UIView {
    func interactableControlAt(location: CGPoint) -> UIControl? {
        return interactableControlAt(location: location, rootView: self)
    }
    
    private func interactableControlAt(location: CGPoint, rootView: UIView) -> UIControl? {
        for subview in subviews {
            guard subview.isUserInteractionEnabled else {
                continue
            }
            
            guard !subview.isHidden else {
                continue
            }
            
            let subviewFrameInRootView = subview.convert(subview.bounds, to: rootView)
            
            guard subviewFrameInRootView.contains(location) else {
                continue
            }
            
            if let control = subview as? UIControl {
                return control
            } else if let controlInNestedSubviews = subview.interactableControlAt(location: location, rootView: rootView) {
                return controlInNestedSubviews
            }
        }
        
        return nil
    }
}
