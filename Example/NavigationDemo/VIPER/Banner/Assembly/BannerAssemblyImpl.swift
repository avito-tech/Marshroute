import UIKit
import Marshroute

final class BannerAssemblyImpl: BaseAssembly, BannerAssembly {
    // MARK: - BannerAssembly
    func module() -> (view: UIView, moduleInput: BannerModuleInput)
    {
        let timerService = serviceFactory.timerService()
        
        let interactor = BannerInteractorImpl(
            timerService: timerService
        )
        
        let presenter = BannerPresenter(
            interactor: interactor
        )
        
        let view = BannerView()
        view.addDisposable(presenter)
        
        presenter.view = view
        
        return (view, presenter)
    }
}