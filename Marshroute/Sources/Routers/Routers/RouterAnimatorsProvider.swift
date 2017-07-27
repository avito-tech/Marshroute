/// Методы для создания кастомных аниматоров переходов, используемых базовыми роутерами по-умолчанию
public protocol RouterAnimatorsProvider: class {
    func setNavigationTransitionsAnimator() -> SetNavigationTransitionsAnimator
    func resetNavigationTransitionsAnimator() -> ResetNavigationTransitionsAnimator
    func navigationTransitionsAnimator() -> NavigationTransitionsAnimator
    
    func modalTransitionsAnimator() -> ModalTransitionsAnimator 
    func modalMasterDetailTransitionsAnimator() -> ModalMasterDetailTransitionsAnimator
    
    func popoverTransitionsAnimator() -> PopoverTransitionsAnimator
    func popoverNavigationTransitionsAnimator() -> PopoverNavigationTransitionsAnimator
}
