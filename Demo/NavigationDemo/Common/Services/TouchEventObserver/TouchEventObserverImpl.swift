import UIKit

/// Used to hold weak references on `TouchEventListener`s
private struct TouchEventListenerWeakBox {
    weak var listener: TouchEventListener?
}

final class TouchEventObserverImpl: TouchEventObserver, TouchEventForwarder {
    // MARK: - Init
    private var touchListenerBoxes = [TouchEventListenerWeakBox]()
    
    // MARK: - TouchEventObserver
    func addListener(listener: TouchEventListener) {
        // Release some memory
        touchListenerBoxes = touchListenerBoxes.filter { $0.listener != nil }
        
        // Check if listener is already registered
        guard touchListenerBoxes.indexOf({ $0.listener === listener }) == nil
            else { return } // `Set` could be useful, but it has some nasty constraints
        
        // Register listener
        let listenerBox = TouchEventListenerWeakBox(
            listener: listener
        )
        
        touchListenerBoxes.append(listenerBox)
    }
    
    // MARK: - TouchEventForwarder
    func forwardEvent(event: UIEvent, touches: Set<UITouch>) {
        guard let touch = touches.first
            else { return }
        
        switch touch.phase {
        case .Began:
            for touchListenerBox in touchListenerBoxes {
                touchListenerBox.listener?.touchesBegan(touches, withEvent: event)
            }
            
        case .Moved:
            for touchListenerBox in touchListenerBoxes {
                touchListenerBox.listener?.touchesMoved(touches, withEvent: event)
            }
            
        case .Cancelled:
            for touchListenerBox in touchListenerBoxes {
                touchListenerBox.listener?.touchesCancelled(touches, withEvent: event)
            }
            
        case .Ended:
            for touchListenerBox in touchListenerBoxes {
                touchListenerBox.listener?.touchesEnded(touches, withEvent: event)
            }
            
        case .Stationary:
            break
        }
    }
}