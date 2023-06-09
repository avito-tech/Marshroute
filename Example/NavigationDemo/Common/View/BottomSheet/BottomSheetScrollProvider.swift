import UIKit

protocol BottomSheetScrollProvider: AnyObject {
    func bottomSheetScrollViews() -> [UIScrollView]
}

final class DefaultBottomSheetScrollProvider: BottomSheetScrollProvider {
    func bottomSheetScrollViews() -> [UIScrollView] {
        return []
    }
}
