import UIKit

protocol TouchEventListener: AnyObject {
    func touchesBegan(_ touches: Set<UITouch>, withEvent event: UIEvent?)
    func touchesMoved(_ touches: Set<UITouch>, withEvent event: UIEvent?)
    func touchesEnded(_ touches: Set<UITouch>, withEvent event: UIEvent?)
    func touchesCancelled(_ touches: Set<UITouch>?, withEvent event: UIEvent?)
}
