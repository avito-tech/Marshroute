public final class RouterAnimatorsProviderImpl: RouterAnimatorsProvider 
{
    // MARK: - Init
    public init() {}
    
    // MARK: - RouterAnimatorsProvider
    public func setNavigationTransitionsAnimator() -> SetNavigationTransitionsAnimator {
        return SetNavigationTransitionsAnimator()
    }
    
    public func resetNavigationTransitionsAnimator() -> ResetNavigationTransitionsAnimator {
        return ResetNavigationTransitionsAnimator()
    }
    
    public func navigationTransitionsAnimator() -> NavigationTransitionsAnimator {
        return NavigationTransitionsAnimator()
    }
    
    public func modalTransitionsAnimator() -> ModalTransitionsAnimator {
        return ModalTransitionsAnimator()
    }
    
    public func modalMasterDetailTransitionsAnimator() -> ModalMasterDetailTransitionsAnimator {
        return ModalMasterDetailTransitionsAnimator()
    }
    
    public func popoverTransitionsAnimator() -> PopoverTransitionsAnimator {
        return PopoverTransitionsAnimator()
    }
    
    public func popoverNavigationTransitionsAnimator() -> PopoverNavigationTransitionsAnimator {
        return PopoverNavigationTransitionsAnimator()
    }
}
