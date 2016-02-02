import Foundation

class AuthorizationPresenter {
    private let interactor: AuthorizationInteractor
    private let router: AuthorizationRouter
    
    weak var viewInput: AuthorizationViewInput?
    weak var moduleOutput: AuthorizationModuleOutput?
    
    //MARK: - Init
    init(interactor: AuthorizationInteractor, router: AuthorizationRouter){
        self.interactor = interactor
        self.router = router
    }
    
    deinit {
        moduleOutput?.didFinishWith(success: false)
    }
    
}

//MARK: - AuthorizationInput
extension AuthorizationPresenter: AuthorizationModuleInput  {
    
}

//MARK: - AuthorizationViewOutput
extension AuthorizationPresenter: AuthorizationViewOutput  {
    func userDidCancel() {
        moduleOutput?.didFinishWith(success: false)
        moduleOutput = nil
        router.dismissCurrentModule()
    }
    
    func userDidAuth() {
        // дожидаемся, пока наш модуль будет сокрыт, а затем сообщаем о результате работы в выход
        router.dismissWithCompletion { [weak self]  () -> Void in
            self?.moduleOutput?.didFinishWith(success: true)
            self?.moduleOutput = nil
        }
    }
}