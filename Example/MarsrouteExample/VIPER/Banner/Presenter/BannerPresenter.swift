import Foundation

final class BannerPresenter: BannerModuleInput {
    // MARK: - Init
    fileprivate let interactor: BannerInteractor
    
    init(interactor: BannerInteractor) {
        self.interactor = interactor
    }
    
    // MARK: - Weak properties
    weak var view: BannerViewInput? {
        didSet {
            if oldValue !== view {
                setupView()
            }
        }
    }
    
    // MARK: - Private
    fileprivate func setupView() {
        view?.onTap = { [weak self] in
            self?.interactor.invalidateTimer()
            self?.onBannerTap?()
        }
        
        view?.onTouchDown = { [weak self] in
            self?.interactor.invalidateTimer()
        }
        
        view?.onTouchUpOutside = { [weak self] in
            self?.onBannerTimeout?()
        }
    }
    
    // MARK: - BannerModuleInput
    func setTitle(_ title: String) {
        view?.setTitle(title)
    }
    
    func setPresented() {
        interactor.startTimer(
            onTick: nil,
            onFire: { [weak self] in
                self?.onBannerTimeout?()
            }
        )
    }
    
    var onBannerTap: (() -> ())?
    var onBannerTimeout: (() -> ())?
}
