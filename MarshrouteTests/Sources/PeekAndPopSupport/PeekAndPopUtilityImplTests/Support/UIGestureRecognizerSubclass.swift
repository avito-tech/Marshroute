import UIKit.UIGestureRecognizerSubclass

// Used to manually call `action` on a `target` on `state` changes
final class TestableGestureRecognizer: UIGestureRecognizer {
    weak var target: AnyObject?
    var action: Selector?
    
    override init(target: Any?, action: Selector?) {
        super.init(target: nil, action: nil)
        self.target = target as AnyObject
        self.action = action
    }
    
    override func addTarget(_ target: Any, action: Selector) {
        self.target = target as AnyObject
        self.action = action
        super.addTarget(target, action: action)
    }
    
    override func removeTarget(_ target: Any?, action: Selector?) {
        self.target = nil
        self.action = nil
        super.removeTarget(target, action: action)
    }
    
    override var state: UIGestureRecognizerState {
        didSet {
            if let target = target, let action = action {
                _ = target.perform(action, with: self)
            }
        }
    }
}
