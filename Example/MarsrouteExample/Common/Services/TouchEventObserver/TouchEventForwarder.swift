import UIKit

protocol TouchEventForwarder: class {
    func forwardEvent(_ event: UIEvent, touches: Set<UITouch>)
}
