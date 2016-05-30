import UIKit

protocol TouchEventListener: class {
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?)
}