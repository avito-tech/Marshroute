import UIKit

/// Used to hold weak references on `TouchEventListener`s
private struct TouchEventListenerWeakBox {
    weak var listener: TouchEventListener?
}

final class TouchEventObserverImpl: TouchEventObserver, TouchEventForwarder {
    // MARK: - Init
    private var touchListenerBoxes = [TouchEventListenerWeakBox]()
    
    // MARK: - TouchEventObserver
    func addListener(_ listener: TouchEventListener) {
        // Release some memory
        touchListenerBoxes = touchListenerBoxes.filter { $0.listener != nil }
        
        // Check if listener is already registered
        guard touchListenerBoxes.firstIndex(where: { $0.listener === listener }) == nil
            else { return } // `Set` could be useful, but it has some nasty constraints
        
        // Register listener
        let listenerBox = TouchEventListenerWeakBox(
            listener: listener
        )
        
        touchListenerBoxes.append(listenerBox)
    }
    
    // MARK: - TouchEventForwarder
    func forwardEvent(_ event: UIEvent, touches: Set<UITouch>) {
        guard let touch = touches.first
            else { return }
        
        switch touch.phase {
        case .began:
            for touchListenerBox in touchListenerBoxes {
                touchListenerBox.listener?.touchesBegan(touches, withEvent: event)
            }
            
        case .moved:
            for touchListenerBox in touchListenerBoxes {
                touchListenerBox.listener?.touchesMoved(touches, withEvent: event)
            }
            
        case .cancelled:
            for touchListenerBox in touchListenerBoxes {
                touchListenerBox.listener?.touchesCancelled(touches, withEvent: event)
            }
            
        case .ended:
            for touchListenerBox in touchListenerBoxes {
                touchListenerBox.listener?.touchesEnded(touches, withEvent: event)
            }
            
        case .stationary:
            break
        }
    }
}
