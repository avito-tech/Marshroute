import Foundation

public protocol AvitoNavigationSetupService: class {
    func avitoNavigationStack()
        -> AvitoNavigationStack
    
    func avitoNavigationStack(transitionContextsStackClientProvider: TransitionContextsStackClientProvider)
        -> AvitoNavigationStack
}
