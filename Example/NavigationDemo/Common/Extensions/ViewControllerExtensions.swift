import UIKit

extension UIViewController {
    var defaultContentInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets
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
