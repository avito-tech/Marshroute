import UIKit
import Marshroute

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate
{
    var window: UIWindow?
    
    // Auxiliary window to show touch marker (even over `UIPopoverController`).
    // It should be created lazily, because `UIKit` works incorrenctly
    // if you create two `UIWindow`s at `application(_:didFinishLaunchingWithOptions:)`
    fileprivate lazy var touchCursorDrawingWindow: UIWindow? = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        window.isUserInteractionEnabled = false
        window.windowLevel = UIWindowLevelStatusBar
        window.backgroundColor = .clear
        window.isHidden = false
        window.rootViewController = self.window?.rootViewController
        
        return window
    }()
    
    fileprivate var touchCursorDrawer: TouchCursorDrawerImpl?
    
    fileprivate var touchCursorDrawingWindowProvider: (() -> (UIWindow?)) {
        return { [weak self] in
            return self?.touchCursorDrawingWindow
        }
    }
    
    fileprivate var touchEventObserver: TouchEventObserver?

    fileprivate var rootTransitionsHandler: ContainingTransitionsHandler?
    
    fileprivate var rootTransitionsHandlerProvider: (() -> (ContainingTransitionsHandler?)) {
        return { [weak self] in
            return self?.rootTransitionsHandler
        }
    }
    
    // MARK: - UIApplicationDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        // Init `Marshroute` stack
        let marshrouteSetupService = MarshrouteSetupServiceImpl()
        
        let applicationModuleSeed = ApplicationModuleSeedProvider().applicationModuleSeed(
            marshrouteSetupService: marshrouteSetupService
        )
        
        // Init service factory
        let serviceFactory = ServiceFactoryImpl(
            topViewControllerFinder: applicationModuleSeed.marshrouteStack.topViewControllerFinder,
            rootTransitionsHandlerProvider: rootTransitionsHandlerProvider,
            transitionsMarker: applicationModuleSeed.marshrouteStack.transitionsMarker,
            transitionsTracker: applicationModuleSeed.marshrouteStack.transitionsTracker,
            transitionsCoordinatorDelegateHolder: applicationModuleSeed.marshrouteStack.transitionsCoordinatorDelegateHolder
        )
        
        // Init assemly factory
        let assemblyFactory = AssemblyFactoryImpl(
            serviceFactory: serviceFactory,
            marshrouteStack: applicationModuleSeed.marshrouteStack
        )
        
        let applicationModule: ApplicationModule
            
        if UIDevice.current.userInterfaceIdiom == .pad {
            applicationModule = assemblyFactory.applicationAssembly().ipadModule(moduleSeed: applicationModuleSeed)
        } else {
            applicationModule = assemblyFactory.applicationAssembly().module(moduleSeed: applicationModuleSeed)
        }
        
        rootTransitionsHandler = applicationModule.transitionsHandler
        
        // Main application window, which shares delivered touch events with its `touchEventForwarder`
        let touchEventSharingWindow = TouchEventSharingWindow(frame: UIScreen.main.bounds)
        touchEventSharingWindow.rootViewController = applicationModule.viewController
        touchEventSharingWindow.touchEventForwarder = serviceFactory.touchEventForwarder()
        
        // Object for drawing temporary red markers in places where user touches the screen
        let touchCursorDrawer = TouchCursorDrawerImpl(windowProvider: touchCursorDrawingWindowProvider)
        self.touchCursorDrawer = touchCursorDrawer
        
        let touchEventObserver = serviceFactory.touchEventObserver()
        touchEventObserver.addListener(touchCursorDrawer)
        self.touchEventObserver = touchEventObserver
        
        window = touchEventSharingWindow
        window?.makeKeyAndVisible()

        return true
    }
}
