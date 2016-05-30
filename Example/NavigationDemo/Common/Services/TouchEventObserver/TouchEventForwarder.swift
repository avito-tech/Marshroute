import UIKit

protocol TouchEventForwarder: class {
    func forwardEvent(event: UIEvent, touches: Set<UITouch>)
}
