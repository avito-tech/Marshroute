import UIKit

final class BottomSheetTransitionConfiguration {
    // MARK: - Properties -
    let dimmingStyle: BottomSheetDimmingViewStyle
    let isCancelable: Bool
    let initialState: BottomSheetViewState
    var allowStateChange: Bool
    let shouldFollowKeyboard: Bool
    var onManualDismiss: (() -> ())?
    
    // MARK: - Init -
    init(
        dimmingStyle: BottomSheetDimmingViewStyle = .translucent,
        isCancelable: Bool = true,
        initialState: BottomSheetViewState = .bottomSheet,
        allowStateChange: Bool = true,
        shouldFollowKeyboard: Bool = false,
        onManualDismiss: (() -> ())? = nil
    ) {
        self.dimmingStyle = dimmingStyle
        self.isCancelable = isCancelable
        self.initialState = initialState
        self.allowStateChange = allowStateChange
        self.shouldFollowKeyboard = shouldFollowKeyboard
        self.onManualDismiss = onManualDismiss
    }
}
