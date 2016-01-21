protocol RouterDismisable: class {
    /// Чтобы router мог попросить убрать себя с экрана, храним слабую ссылку на родительский router
    weak var parentRouter: RouterDismisable? { get set }
    
    func dismissChildRouter(child: RouterDismisable)
}

extension RouterDismisable {
    func dismissSelf() {
        parentRouter?.dismissChildRouter(self)
    }
}