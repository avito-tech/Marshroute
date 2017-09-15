import UIKit

final class TouchEventSharingWindow: UIWindow {
    weak var touchEventForwarder: TouchEventForwarder?
    
    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        
        guard let allTouches = event.allTouches
            else { return }
        
        self.touchEventForwarder?.forwardEvent(event, touches: allTouches)
    }
}
