import UIKit

final class TouchCursorDrawerImpl: TouchEventListener {
    // MARK: - Init
    fileprivate let windowProvider: (() -> (UIWindow?))
    fileprivate var fadeOutViews = [FadeOutView]()
    
    init(windowProvider: @escaping (() -> (UIWindow?))) {
        self.windowProvider = windowProvider
    }
    
    // MARK - TouchEventListener
    func touchesBegan(_ touches: Set<UITouch>, withEvent event: UIEvent?) {
        addFadeOutViewsForTouches(touches)
    }
    
    func touchesMoved(_ touches: Set<UITouch>, withEvent event: UIEvent?) {
        removeFadeOutViews()
        addFadeOutViewsForTouches(touches)
    }
    
    func touchesEnded(_ touches: Set<UITouch>, withEvent event: UIEvent?) {
        removeFadeOutViews()
    }
    
    func touchesCancelled(_ touches: Set<UITouch>?, withEvent event: UIEvent?) {
        removeFadeOutViews()
    }
    
    // MARK: - Private
    fileprivate func addFadeOutViewsForTouches(_ touches: Set<UITouch>) {
        guard let window = windowProvider()
            else { return }
        
        for touch in touches {
            let fadeOutView = FadeOutView()
            fadeOutView.center = touch.location(in: window)
            window.addSubview(fadeOutView)
            fadeOutViews.append(fadeOutView)
        }
    }
    
    fileprivate func removeFadeOutViews() {
        for fadeOutView in fadeOutViews {
            fadeOutView.fadeOut()
        }
        
        self.fadeOutViews.removeAll()
    }
}
