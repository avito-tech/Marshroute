import UIKit
import Marshroute

final class InitialNavigationStateInitializer {
    // MARK: - Private properties
    private let assemblyFactory: AssemblyFactory
    private let marshrouteFacade: MarshrouteFacade
    
    // MARK: - Init
    init(
        assemblyFactory: AssemblyFactory,
        marshrouteStack: MarshrouteStack)
    {
        self.assemblyFactory = assemblyFactory
        
        self.marshrouteFacade = MarshrouteFacade(
            marshrouteStack: marshrouteStack
        )
    }
    
    // MARK: - Internal
    func module(isPad: Bool)
        -> AssembledMarshrouteModule<UITabBarController, ApplicationModule>
    {
        var result: AssembledMarshrouteModule<UITabBarController, ApplicationModule>!
        
        let tabViewControllerDeriviationFunctions = self.tabViewControllerDeriviationFunctions(isPad: isPad)
        
        let _ = marshrouteFacade.tabBarModule(
            tabViewControllerDeriviationFunctions: tabViewControllerDeriviationFunctions,
            deriveTabBarController: { [assemblyFactory] routerSeed, instantiateTabViewControllers in
                result = assemblyFactory.applicationAssembly().module(
                    routerSeed: routerSeed,
                    instantiateTabViewControllers: instantiateTabViewControllers,
                    isPad: isPad
                )
                
                return result.viewController
            }
        )
        
        return result
    }
    
    // MARK: - Private
    private func tabViewControllerDeriviationFunctions(isPad: Bool)
        -> [TabViewControllerDeriviationFunctionType]
    {
        return isPad 
            ? ipadTabViewControllerDeriviationFunctions()
            : iponeTabViewControllerDeriviationFunctions()
    }
    
    private func iponeTabViewControllerDeriviationFunctions()
        -> [TabViewControllerDeriviationFunctionType]
    {
        let result: [TabViewControllerDeriviationFunctionType] = [
            .deriveDetailViewControllerInNavigationController { [assemblyFactory] routerSeed in
                assemblyFactory.categoriesAssembly().module(routerSeed: routerSeed)
            },
            .deriveDetailViewControllerInNavigationController { [assemblyFactory] routerSeed in
                assemblyFactory.recursionAssembly().module(routerSeed: routerSeed)
            }
        ]
        return result
    }
    
    private func ipadTabViewControllerDeriviationFunctions()
        -> [TabViewControllerDeriviationFunctionType]
    {
        let result: [TabViewControllerDeriviationFunctionType] = [
            .deriveMasterDetailViewController(
                masterViewControllerInNavigationController: { [assemblyFactory] routerSeed in
                    assemblyFactory.categoriesAssembly().ipadMasterDetailModule(routerSeed: routerSeed)
                },
                detailViewControllerInNavigationController: { [assemblyFactory] routerSeed in
                    assemblyFactory.shelfAssembly().module(routerSeed: routerSeed)
                }
            ),
            .deriveDetailViewControllerInNavigationController { [assemblyFactory] routerSeed in
                assemblyFactory.recursionAssembly().module(routerSeed: routerSeed)
            }
        ]
        return result
    }
}
