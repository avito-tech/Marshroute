import Foundation

public protocol MarshrouteFactory: class {
    func transitionContextsStackClientProvider()
        -> TransitionContextsStackClientProvider
    
    func transitionIdGenerator()
        -> TransitionIdGenerator
    
    func routerControllersProvider()
        -> RouterControllersProvider
}
