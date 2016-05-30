import Foundation

final public class AvitoNavigationFactoryImpl: AvitoNavigationFactory {
    // MARK: - Init
    public init() {}
    
    // MARK: - AvitoNavigationFactory
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