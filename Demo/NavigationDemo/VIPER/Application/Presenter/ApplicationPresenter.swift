import Foundation

final class ApplicationPresenter: ApplicationModuleInput, AuthorizationModuleOutput {
    // MARK: - Init
    private let interactor: ApplicationInteractor
    
    private let router: ApplicationRouter
    
    private var authorizationCompletion: ((isAuthorized: Bool) -> ())?
    private var isShowingAuthorizationModule = false
    
    init(interactor: ApplicationInteractor, router: ApplicationRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Weak properties
    weak var view: ApplicationViewInput? {
        didSet {
            setupView()
        }
    }
    
    weak var bannerModuleInput: BannerModuleInput?
    
    // MARK: - Private
    private func setupView() {
        view?.onMemoryWarning = { [weak self] in
            self?.showAuthorizationModule(nil)
        }
        
        view?.onDeviceShake = { [weak self] in
            self?.interactor.bannerType { bannerType in
                self?.showBanner(bannerType: bannerType)
            }
        }
    }
    
    // MARK: - ApplicationModuleInput
    func showAuthorizationModule(completion: ((isAuthorized: Bool) -> ())?) {
        authorizationCompletion = completion
        
        guard !isShowingAuthorizationModule
            else { return }
        
        isShowingAuthorizationModule = true
        
        router.showAuthorziation(moduleOutput: self)
    }
    
    // MARK: - AuthorizationModuleOutput
    func autorizationModuleDidFinish(isAuthorized isAuthorized: Bool) {
        isShowingAuthorizationModule = false
        authorizationCompletion?(isAuthorized: isAuthorized)
    }
    
    // MARK: - Private
    func showBanner(bannerType bannerType: BannerType) {
        let onBannerTap: (() -> ())
        
        switch bannerType {
        case .Categories:
            bannerModuleInput?.setTitle("notification.toCategories".localized)
            
            onBannerTap = { [weak self] in
                self?.router.showCategories()
            }
            
        case .Recursion:
            bannerModuleInput?.setTitle("notification.toRecursion".localized)
            
            onBannerTap = { [weak self] in
                self?.router.showRecursion()
            }
        }
        
        showBanner(onBannerTap: onBannerTap)
    }
    
    private func showBanner(onBannerTap onBannerTap: (() -> ())) {
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
