import UIKit

final class ShelfViewController:
    BaseViewController,
    ShelfViewInput,
    BottomSheetPresentable,
    BottomSheetHeightProvider,
    BottomSheetPresentableLifecycle
{
    // MARK: - Private properties
    private let style: ShelfStyle
    private let shelfView = ShelfView()
    
    // MARK: - State
    private var onLeftButtonTap: (() -> ())?
    private var onRightButtonTap: (() -> ())?
    
    // MARK: - Init
    init(style: ShelfStyle) {
        self.style = style
        super.init()
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = shelfView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setTopRoundCorners(radius: Spec.bottomSheetCornerRadius)
        shelfView.defaultContentInsets = defaultContentInsets
    }
    
    override var preferredContentSize: CGSize {
        get {
            let width = Spec.width(style: style)
            return CGSize(width: width, height: Spec.buttonSheetHeight)
        }
        set {
            super.preferredContentSize = newValue
        }
    }
    
    // MARK: - ShelfViewInput
    @nonobjc func setTitle(_ title: String?) {
        self.title = title
    }
    
    @objc private func onLeftButtonTap(_ sender: UIBarButtonItem) {
        onLeftButtonTap?()
    }
    
    @objc private func onRightButtonTap(_ sender: UIBarButtonItem) {
        onRightButtonTap?()
    }
    
    // MARK: - ShelfViewInput
    func setLeftBarButton(_ buttonItem: ButtonItem) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: buttonItem.title,
            style: .plain,
            target: self,
            action: #selector(onLeftButtonTap(_:))
        )
        onLeftButtonTap = buttonItem.onTap
    }
    
    func setRightBarButton(_ buttonItem: ButtonItem) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: buttonItem.title,
            style: .plain,
            target: self,
            action: #selector(onRightButtonTap(_:))
        )
        onRightButtonTap = buttonItem.onTap
    }
    
    var onBottomSheetDismiss: (() -> ())?
    
    // MARK: - BottomSheetHeightProvider
    func bottomSheetHeight(forContainerSize containerSize: CGSize) -> CGFloat {
        return Spec.buttonSheetHeight
    }
    
    // MARK: - BottomSheetPresentableLifecycle
    func bottomSheetShouldDismiss() -> Bool {
        return true
    }
    
    func bottomSheetDidChangeViewState(state: BottomSheetViewState) {
        onManualDismiss = onBottomSheetDismiss
    }
}

private struct Spec {
    static func width(style: ShelfStyle) -> CGFloat {
        switch style {
        case .root,
             .modalWithNavigationBar:
            return UIScreen.main.bounds.width
        case .modalBottomSheetWithNavigationBar,
             .modalBottomSheetWithoutNavigationBar:
            return 320
        }
    }
        
    static let bottomSheetCornerRadius: CGFloat = 20
    
    static let buttonSheetHeight: CGFloat = 500
}
