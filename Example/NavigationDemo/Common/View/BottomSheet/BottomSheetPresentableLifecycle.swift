protocol BottomSheetPresentableLifecycle: AnyObject {
    func bottomSheetDidChangeViewState(state: BottomSheetViewState)
    func bottomSheetShouldDismiss() -> Bool
}

extension BottomSheetPresentableLifecycle {
    func bottomSheetShouldDismiss() -> Bool { true }
    func bottomSheetDidChangeViewState(state: BottomSheetViewState) { }
}
