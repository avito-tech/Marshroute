import Foundation

final public class MarshrouteFactoryImpl: MarshrouteFactory {
    // MARK: - Init
    public init() {}
    
    // MARK: - MarshrouteFactory
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
