import Foundation

final class ApplicationPresenter: ApplicationModule {
    // MARK: - Init
    fileprivate let interactor: ApplicationInteractor
    
    fileprivate let router: ApplicationRouter
    
    init(interactor: ApplicationInteractor, router: ApplicationRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Weak properties
    weak var view: ApplicationViewInput? {
        didSet {
            if oldValue !== view {
                setupView()
            }
        }
    }
    
    weak var authorizationModuleInput: AuthorizationModuleInput?
    
    weak var bannerModuleInput: BannerModuleInput?
    
    // MARK: - Private
    fileprivate func setupView() {
        view?.onMemoryWarning = { [weak self] in
            self?.showAuthorizationModule(nil)
        }
        
        view?.onDeviceShake = { [weak self] in
            self?.interactor.bannerType { bannerType in
                self?.showBanner(bannerType: bannerType)
            }
        }
    }
    
    // MARK: - ApplicationModule
    func showAuthorizationModule(_ completion: ((_ isAuthorized: Bool) -> ())?) {
        router.authorizationStatus { [weak self] isPresented in
            if isPresented {
                self?.authorizationModuleInput?.onComplete = completion
            } else {
                self?.router.showAuthorization { [weak self] moduleInput in
                    self?.authorizationModuleInput = moduleInput
                    moduleInput.onComplete = completion
                }
            }
        }
    }
    
    // MARK: - Private
    func showBanner(bannerType: BannerType) {
        let onBannerTap: (() -> ())
        
        switch bannerType {
        case .categories:
            bannerModuleInput?.setTitle("notification.toCategories".localized)
            
            onBannerTap = { [weak self] in
                self?.router.showCategories()
            }
            
        case .recursion:
            bannerModuleInput?.setTitle("notification.toRecursion".localized)
            
            onBannerTap = { [weak self] in
                self?.router.showRecursion()
            }
        }
        
        showBanner(onBannerTap: onBannerTap)
    }
    
    fileprivate func showBanner(onBannerTap: @escaping (() -> ())) {
        view?.showBanner { [weak self] in
            self?.bannerModuleInput?.setPresented()
            
            self?.bannerModuleInput?.onBannerTap = {
                self?.interactor.switchBannerType()
                self?.view?.hideBanner()
                onBannerTap()
            }
            
            self?.bannerModuleInput?.onBannerTimeout = {
                self?.view?.hideBanner()
            }
        }
    }
}
