import UIKit

protocol TouchEventListener: class {
    func touchesBegan(_ touches: Set<UITouch>, withEvent event: UIEvent?)
    func touchesMoved(_ touches: Set<UITouch>, withEvent event: UIEvent?)
    func touchesEnded(_ touches: Set<UITouch>, withEvent event: UIEvent?)
    func touchesCancelled(_ touches: Set<UITouch>?, withEvent event: UIEvent?)
}
