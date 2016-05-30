import UIKit

final class TouchCursorDrawerImpl: TouchEventListener {
    // MARK: - Init
    private let windowProvider: (() -> (UIWindow?))
    private var fadeOutViews = [FadeOutView]()
    
    init(windowProvider: (() -> (UIWindow?))) {
        self.windowProvider = windowProvider
    }
    
    // MARK - TouchEventListener
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        addFadeOutViewsForTouches(touches)
    }
    
    func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        removeFadeOutViews()
        addFadeOutViewsForTouches(touches)
    }
    
    func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        removeFadeOutViews()
    }
    
    func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        removeFadeOutViews()
    }
    
    // MARK: - Private
    private func addFadeOutViewsForTouches(touches: Set<UITouch>) {
        guard let window = windowProvider()
            else { return }
        
        for touch in touches {
            let fadeOutView = FadeOutView()
            fadeOutView.center = touch.locationInView(window)
            window.addSubview(fadeOutView)
            fadeOutViews.append(fadeOutView)
        }
    }
    
    private func removeFadeOutViews() {
        for fadeOutView in fadeOutViews {
            fadeOutView.fadeOut()
        }
        
        self.fadeOutViews.removeAll()
    }
}