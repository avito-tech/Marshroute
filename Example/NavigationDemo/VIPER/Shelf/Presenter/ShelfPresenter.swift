import Foundation

final class ShelfPresenter: ShelfModule {
    // MARK: - Init
    private let style: ShelfStyle
    private let interactor: ShelfInteractor
    private let router: ShelfRouter
    
    init(
        style: ShelfStyle,
        interactor: ShelfInteractor,
        router: ShelfRouter)
    {
        self.style = style
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Weak properties
    weak var view: ShelfViewInput? {
        didSet {
            if oldValue !== view {
                setupView()
            }
        }
    }
    
    // MARK: - Private
    private func setupView() {
        view?.onViewDidLoad = { [weak self] in
            guard let self else { return }
            
            self.view?.setTitle(self.title())
            self.setLeftButtonItem()
            self.setRightButtonItem()
        }
        
        view?.onBottomSheetDismiss = { [weak self] in
            self?.finish()
        }

    }
    
    private func title() -> String {
        switch style {
        case .root:
            return "shelves.root".localized
        case .modalWithNavigationBar:
            return "shelves.modal".localized
        case .modalBottomSheetWithNavigationBar:
            return "shelves.buttomSheet".localized
        case .modalBottomSheetWithoutNavigationBar:
            return ""
        }
    }
    
    private func setLeftButtonItem() {
        guard style != .root else { return }
        
        view?.setLeftBarButton(
            ButtonItem(
                title: "cancel".localized,
                onTap: { [weak self] in
                    self?.finish()
                }
            )
        )
    }
    
    private func setRightButtonItem() {
        guard let nextStyle = ShelfStyle(rawValue: style.rawValue + 1) else { return }
        
        view?.setRightBarButton(
            ButtonItem(
                title: "shelves".localized,
                onTap: { [weak self] in
                    guard let self else { return }
                    self.router.showShelf(
                        style: nextStyle,
                        configure: { module in
                            module.onFinish = { module, result in
                                switch result {
                                case .cancelled:
                                    // Тут выполняется закрытие модуля Shelf, который УЖЕ может быть закрыт.
                                    // Это возможно, если модуль Shelf был открыт в формате шторки
                                    // через `.modalBottomSheetWithNavigationBar` или `.modalBottomSheetWithoutNavigationBar`)
                                    // и при этом был закрыт свайпом шторки вниз или тапом по затемнению вокруг шторки.
                                    //
                                    // Этим кодом мы проверяем функциональность Marshroute'а игнорировать второе закрытие
                                    // модального открытого экрана
                                    // (см `isDescribingScreenThatWasAlreadyDismissedWithoutInvokingMarshroute`).
                                    //
                                    // Однако, стоит заметить, что эта функциональность работает ТОЛЬКО если в текущий код
                                    // мы попадаем после анимации закрытия шторки. Иными словами, если сюда мы попадаем
                                    // из completion'а вызова `-[UIViewController dismissViewControllerAnimated:completion:]`.
                                    // В противном случае пропертя `presentedViewController` у экрана под шторкой
                                    // будет все еще не nil (таков UIKit).
                                    module.dismissCurrentModule()
                                }
                            }
                        }
                    )
                }
            )
        )
    }
    
    private func finish() {
        onFinish?(self, .cancelled)
    }
    
    // MARK: - ShelfModule
    func dismissCurrentModule() {
        router.dismissCurrentModule()
    }
    
    var onFinish: ((ShelfModule, ShelfResult) -> ())?
}
