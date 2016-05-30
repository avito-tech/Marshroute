import Foundation

public protocol AvitoNavigationFactory: class {
    func transitionContextsStackClientProvider()
        -> TransitionContextsStackClientProvider
    
    func transitionIdGenerator()
        -> TransitionIdGenerator
    
    func routerControllersProvider()
        -> RouterControllersProvider
}