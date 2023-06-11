import UIKit

enum BottomSheetDimmingViewStyle {
    case translucent, opaque
}

protocol BottomSheetDimmingViewProvider: AnyObject {
    func dimmingView(frame: CGRect, style: BottomSheetDimmingViewStyle) -> UIView
}

final class DefaultBottomSheetDimmingView: UIView {
    init(frame: CGRect, style: BottomSheetDimmingViewStyle) {
        super.init(frame: .zero)
        
        switch style {
        case .translucent:
            backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        case .opaque:
            backgroundColor = UIColor.black
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class DefaultBottomSheetDimmingViewProvider: BottomSheetDimmingViewProvider {
    func dimmingView(frame: CGRect, style: BottomSheetDimmingViewStyle) -> UIView {
        return DefaultBottomSheetDimmingView(frame: frame, style: style)
    }
}
