import UIKit

protocol TouchEventForwarder: AnyObject {
    func forwardEvent(_ event: UIEvent, touches: Set<UITouch>)
}
