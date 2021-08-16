import Foundation

protocol BannerViewInput: AnyObject {
    func setTitle(_ title: String)
    
    var onTouchDown: (() -> ())? { get set }
    var onTap: (() -> ())? { get set }
    var onTouchUpOutside: (() -> ())? { get set }
}
