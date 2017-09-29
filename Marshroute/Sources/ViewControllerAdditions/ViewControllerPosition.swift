// Was not designed to support popovers. Popovers are considered identical to modal presentation
public enum ViewControllerPosition {
    case root
    case pushed
    case modal
    
    // MARK: - Init
    public init(routerSeed: RouterSeed) {
        if let presentingTransitionsHandler = routerSeed.presentingTransitionsHandler {
            if routerSeed.transitionsHandlerBox.unbox() === presentingTransitionsHandler {
                self = .pushed
            } else {
                self = .modal
            }
        } else {
            self = .root
        }
    }
    
    public init(masterDetailRouterSeed routerSeed: MasterDetailRouterSeed) {
        if let presentingTransitionsHandler = routerSeed.presentingTransitionsHandler {
            if routerSeed.masterTransitionsHandlerBox.unbox() === presentingTransitionsHandler {
                self = .pushed
            } else {
                self = .modal
            }
        } else {
            self = .root
        }
    }
}
