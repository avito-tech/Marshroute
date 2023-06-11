import UIKit

// Marker protocol
// Без наследования от AnyObject происходит крэш в рантайме,
// если позвать методы из extension BottomSheetPresentable у объекта, скастованного к типу BottomSheetPresentable
// https://bugs.swift.org/browse/SR-6816
protocol BottomSheetPresentable where Self: UIViewController { }

extension BottomSheetPresentable {
    
    private var bottomSheetPresentationController: BottomSheetTransitionPresentationController? {
        
        // http://www.openradar.me/21753811
        // Обращение к свойству presentationController
        // приводит к лику того контроллера у которого мы это свойство спросили
        return
            BottomSheetTransitionPresentationController.presentationController(forController: self) ??
                BottomSheetTransitionPresentationController.presentationController(
                    forController: self.navigationController)
    }
    
    var isBottomSheetMaximized: Bool? {
        return bottomSheetPresentationController?.bottomSheetViewState == .fullScreen
    }
    
    func bottomSheetMaximize(animated: Bool) {
        
        bottomSheetPresentationController?.setBottomSheetViewState(
            state: .fullScreen,
            animated: animated
        )
    }
    
    func bottomSheetMinimize(animated: Bool) {
        
        bottomSheetPresentationController?.setBottomSheetViewState(
            state: .bottomSheet,
            animated: animated
        )
    }
    
    func updateBottomSheetHeight(animated: Bool = true) {
        guard let controller = bottomSheetPresentationController else { return }
        
        controller.setBottomSheetViewState(
            state: controller.bottomSheetViewState,
            animated: animated
        )
    }
    
    func setTopRoundCorners(radius: CGFloat = 6) {
        guard let navigationView = navigationController?.view ?? view else { return }
        guard let window = navigationView.window else { return }
        
        // Если задать roundedRect = navigationView.bounds, то при анимациях уменьшения фрейма,
        // маска будет обрезать вьюху.
        // Чтобы этого не происходило, делаем маску максимальную по высоте.
        let roundedRect = navigationView.bounds.byChangingBottomAndHeight(window.bounds.size.height * 2)
        
        let path = UIBezierPath(
            roundedRect: roundedRect,
            byRoundingCorners: [.topRight, .topLeft],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        navigationView.layer.mask = maskLayer
    }
    
    func setAllowStateChange(_ allow: Bool) {
        bottomSheetPresentationController?.setAllowStateChange(allow)
    }
    
    var isBottomSheetOpened: Bool {
        return bottomSheetPresentationController != nil
    }
    
    var isInteractiveDissmissInProgress: Bool {
        return bottomSheetPresentationController?.isPanInProgress ?? false
    }
    
    var onManualDismiss: (() -> ())? {
        get { bottomSheetPresentationController?.onManualDismiss }
        set { bottomSheetPresentationController?.onManualDismiss = newValue }
    }
}
