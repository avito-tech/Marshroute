import Marshroute

final class TopViewControllerFindingServiceImpl: TopViewControllerFindingService {
    // MARK: - Init
    let rootTransitionsHandlerProvider: () -> ContainingTransitionsHandler?
    let topViewControllerFinder: TopViewControllerFinder
    
    init(topViewControllerFinder: TopViewControllerFinder,
         rootTransitionsHandlerProvider: @escaping () -> ContainingTransitionsHandler?)
    {
        self.topViewControllerFinder = topViewControllerFinder
        self.rootTransitionsHandlerProvider = rootTransitionsHandlerProvider
    }
    
    // MARK: - TopViewControllerFindingService
    func topViewControllerAndItsContainerViewController()
        -> (UIViewController, UIViewController)?
    {
        guard let topViewController = self.topViewController()
            else { return nil }
        
        let containerViewController = containerViewControllerForViewController(
            topViewController
        )
        
        return (topViewController, containerViewController)
    }
    
    // MARK: - Private 
    fileprivate func topViewController()
        -> UIViewController?
    {
        guard let rootTransitionsHandler = rootTransitionsHandlerProvider()
            else { return nil }
        
        let topViewController = topViewControllerFinder.findTopViewController(
            containingTransitionsHandler: rootTransitionsHandler
        )
        
        return topViewController
    }
    
    fileprivate func containerViewControllerForViewController(_ viewController: UIViewController)
        -> UIViewController
    {
        var containerViewController = viewController
        
        if let navigationController = viewController.navigationController {
            containerViewController = navigationController
        }
        
        if let splitViewController = viewController.splitViewController {
            containerViewController = splitViewController
        }
        
        return containerViewController
    }
}
