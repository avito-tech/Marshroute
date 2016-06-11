import Foundation

public protocol MarshrouteNavigationFactory: class {
    func transitionContextsStackClientProvider()
        -> TransitionContextsStackClientProvider
    
    func transitionIdGenerator()
        -> TransitionIdGenerator
    
    func routerControllersProvider()
        -> RouterControllersProvider
}