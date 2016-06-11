import Foundation

final public class MarshrouteNavigationFactoryImpl: MarshrouteNavigationFactory {
    // MARK: - Init
    public init() {}
    
    // MARK: - MarshrouteNavigationFactory
    public func transitionContextsStackClientProvider()
        -> TransitionContextsStackClientProvider
    {
        return TransitionContextsStackClientProviderImpl()
    }
    
    public func transitionIdGenerator()
        -> TransitionIdGenerator
    {
        return TransitionIdGeneratorImpl()
    }
    
    public func routerControllersProvider()
        -> RouterControllersProvider
    {
        return RouterControllersProviderImpl()
    }
}