import UIKit

extension UIViewController {
    var defaultContentInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return UIEdgeInsets(
                top: topLayoutGuide.length,
                left: 0,
                bottom: view.safeAreaInsets.bottom,
                right: 0
            )
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
