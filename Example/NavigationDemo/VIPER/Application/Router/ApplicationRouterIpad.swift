import UIKit
import Marshroute

final class ApplicationRouterIpad: BaseDemoRouter, ApplicationRouter {
    // MARK: - Private properties
    private let authorizationModuleTrackingService: AuthorizationModuleTrackingService
    
    // MARK: - Init
    init(authorizationModuleTrackingService: AuthorizationModuleTrackingService,
         assemblyFactory: AssemblyFactory,
         routerSeed: RouterSeed)
    {
        self.authorizationModuleTrackingService = authorizationModuleTrackingService
        
        super.init(assemblyFactory: assemblyFactory, routerSeed: routerSeed)
    }
    
    // MARK: - ApplicationRouter
    func authorizationStatus(_ completion: ((_ isPresented: Bool) -> ())) {
        let isAuthorizationModulePresented = authorizationModuleTrackingService.isAuthorizationModulePresented()
        completion(isAuthorizationModulePresented)
    }
    
    func showAuthorization(_ prepareForTransition: ((_ moduleInput: AuthorizationModuleInput) -> ())) {
        let animator = ModalNavigationTransitionsAnimator()
        animator.targetModalPresentationStyle = .formSheet
        
        presentModalNavigationControllerWithRootViewControllerDerivedFrom( { routerSeed -> UIViewController in
            let authorizationAssembly = assemblyFactory.authorizationAssembly()
            
            let (viewController, moduleInput) = authorizationAssembly.module(
                routerSeed: routerSeed
            )
            
            prepareForTransition(moduleInput)
            
            return viewController
        }, animator: animator)
    }
    
    func showCategories() {
        pushViewControllerDerivedFrom { routerSeed -> UIViewController in
            let subcategoriesAssembly = assemblyFactory.categoriesAssembly()
            
            let viewController = subcategoriesAssembly.ipadModule(
                routerSeed: routerSeed
            )
            
            return viewController
        }
    }
    
    func showRecursion() {
        pushViewControllerDerivedFrom { routerSeed -> UIViewController in
            let recursionAssembly = assemblyFactory.recursionAssembly()
            
            let viewController = recursionAssembly.ipadModule(routerSeed: routerSeed)
            
            return viewController
        }
    }
}
