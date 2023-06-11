import UIKit

protocol BottomSheetHeightProvider: AnyObject {
    func bottomSheetHeight(forContainerSize containerSize: CGSize) -> CGFloat
}

final class DefaultBottomSheetHeightProvider: BottomSheetHeightProvider {
    func bottomSheetHeight(forContainerSize containerSize: CGSize) -> CGFloat {
        return containerSize.height * 0.4
    }
}
