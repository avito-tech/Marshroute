import UIKit

extension UIViewController {
    var defaultContentInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return .zero // `view` already hase `safeAreaInsets` on iOS 11
        } else {
            return UIEdgeInsets(
                top: topLayoutGuide.length,
                left: 0,
                bottom: bottomLayoutGuide.length,
                right: 0
            ) 
        }
    }
}
