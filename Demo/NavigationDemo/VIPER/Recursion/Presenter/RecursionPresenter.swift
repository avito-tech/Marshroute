import Foundation

final class RecursionPresenter {
    // MARK: - Init
    private let interactor: RecursionInteractor
    
    private let router: RecursionRouter
    
    init(interactor: RecursionInteractor, router: RecursionRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Weak properties
    weak var view: RecursionViewInput? {
        didSet {
            setupView()
        }
    }
    
    // MARK: - Private
    private func setupView() {
        view?.setTitle("recursion".localized)
        
        view?.onViewDidLoad = { [weak self] in
            self?.interactor.timerStatus { isEnabled in
                self?.view?.setTimerButtonVisible(isEnabled)
                
                if isEnabled {
                    self?.view?.setTimerButtonTitle("comebackTimer.startTimerTitle".localized)
                    
                    self?.view?.onTimerButtonTap = {
                        self?.view?.setTimerButtonEnabled(false)
                        
                        self?.interactor.startTimer(
                            onTick: { secondsLeft in
                                self?.view?.setTimerButtonTitle(
                                    "comebackTimer.secondsLeftTillComeback"
                                        .localizedWithArgument(Int(secondsLeft) as NSNumber)
                                )
                            },
                            onFire: {
                                self?.view?.setTimerButtonEnabled(true)
                                self?.view?.setTimerButtonTitle("comebackTimer.startTimerTitle".localized)
                                self?.router.focusOnCurrentModule()
                            }
                        )
                    }
                }
            }
        }
        
        view?.onRecursionButtonTap = { [weak self] sender in
            self?.router.showRecursion(sender)
        }
        
        view?.onDismissButtonTap = { [weak self ] in
            self?.router.dismissCurrentModule()
        }
        
        view?.onCategoriesButtonTap = { [weak self ] sender in
            self?.router.showCategories(sender)
        }
    }
}
