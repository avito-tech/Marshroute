import Foundation

protocol ShelfViewInput: AnyObject, ViewLifecycleObservable {
    func setTitle(_ title: String?)
    
    func setLeftBarButton(_ buttonItem: ButtonItem)
    func setRightBarButton(_ buttonItem: ButtonItem)
    
    var onBottomSheetDismiss: (() -> ())? { get set }
}
