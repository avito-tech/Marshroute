import Foundation

public protocol MarshrouteFactory: AnyObject {
    func transitionContextsStackClientProvider()
        -> TransitionContextsStackClientProvider
    
    func transitionIdGenerator()
        -> TransitionIdGenerator
    
    func routerControllersProvider()
        -> RouterControllersProvider
}
