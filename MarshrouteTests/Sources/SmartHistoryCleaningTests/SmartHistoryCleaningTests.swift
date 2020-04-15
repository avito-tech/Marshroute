import Marshroute
import XCTest

final class SmartHistoryCleaningTests: XCTestCase {
    func test_marshroute_dismissesTrailingViewController_ifTrailingViewControllerWasPresentedAfterMiddleViewControllerWasDismissedWithoutMarshroute() {
        let recordingMarshrouteAssertionPlugin = RecordingMarshrouteAssertionPlugin()
        MarshrouteAssertionManager.setUpAssertionPlugin(recordingMarshrouteAssertionPlugin)
        
        // =================================== STEP 1. SET LEADING VIEW CONTROLLER ==================================
        
        let (navigationController, _, leadingRouter) = MarshrouteFacade().navigationModule { _ in LeadingViewController() }
        navigationController.assertStackIs([LeadingViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereNoRecordedAssertions()
        
        // =================================== STEP 2. PUSH MIDDLE VIEW CONTROLLER ==================================
        
        leadingRouter.pushWithoutAnimations(MiddleSelfRetainingViewController.self)
        navigationController.assertStackIs([LeadingViewController.self, MiddleSelfRetainingViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereNoRecordedAssertions()
        
        // ====================== STEP 3. REMOVE MIDDLE VIEW CONTROLLER WITHOUT USING MARSHROUTE =====================
        
        _ = navigationController.viewControllers.removeLast()
        navigationController.assertStackIs([LeadingViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereNoRecordedAssertions()
        
        // ================================== STEP 4. PUSH TRAILING VIEW CONTROLLER =================================
        
        let trailingRouter = leadingRouter.pushWithoutAnimations(TrailingViewController.self)
        navigationController.assertStackIs([LeadingViewController.self, TrailingViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereAssertionsAboutSelfRetainingViewControllers(count: 1)
        
        // ================================ STEP 5. DISMISS TRAILING VIEW CONTROLLER ===============================
        // ============================ VALIDATE WE RETURNED TO LEADING VIEW CONTROLLER ===========================
        
        trailingRouter.dismissCurrentModule()
        navigationController.assertStackIs([LeadingViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereAssertionsAboutSelfRetainingViewControllers(count: 1)
    }
    
    func test_marshroute_dismissesTrailingViewController_ifItsPresentingViewControllerWasDismissedWithoutMarshroute() {
        let recordingMarshrouteAssertionPlugin = RecordingMarshrouteAssertionPlugin()
        MarshrouteAssertionManager.setUpAssertionPlugin(recordingMarshrouteAssertionPlugin)
        recordingMarshrouteAssertionPlugin.assertWereNoRecordedAssertions()
        
        // =================================== STEP 1. SET LEADING VIEW CONTROLLER ==================================
        
        let (navigationController, _, leadingRouter) = MarshrouteFacade().navigationModule { _ in LeadingViewController() }
        navigationController.assertStackIs([LeadingViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereNoRecordedAssertions()
        
        // =================================== STEP 2. PUSH MIDDLE VIEW CONTROLLER 1 ==================================
        
        leadingRouter.pushWithoutAnimations(MiddleViewController.self)
        navigationController.assertStackIs([LeadingViewController.self, MiddleViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereNoRecordedAssertions()
        
        // =================================== STEP 3. PUSH MIDDLE VIEW CONTROLLER 2 ==================================
        
        leadingRouter.pushWithoutAnimations(MiddleSelfRetainingViewController.self)
        navigationController.assertStackIs([LeadingViewController.self, MiddleViewController.self, MiddleSelfRetainingViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereNoRecordedAssertions()
        
        // ================================== STEP 4. PUSH TRAILING VIEW CONTROLLER =================================
        
        let trailingRouter = leadingRouter.pushWithoutAnimations(TrailingViewController.self)
        navigationController.assertStackIs([LeadingViewController.self, MiddleViewController.self, MiddleSelfRetainingViewController.self, TrailingViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereNoRecordedAssertions()
        
        // ====================== STEP 5. REMOVE MIDDLE VIEW CONTROLLERS WITHOUT USING MARSHROUTE =====================
        
        _ = navigationController.viewControllers.removeAll { $0 is MiddleViewController || $0 is MiddleSelfRetainingViewController }
        navigationController.assertStackIs([LeadingViewController.self, TrailingViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereNoRecordedAssertions()
        
        // ================================ STEP 6. DISMISS TRAILING VIEW CONTROLLER ===============================
        // ============================ VALIDATE WE RETURNED TO LEADING VIEW CONTROLLER ===========================
        
        trailingRouter.dismissCurrentModule()
        navigationController.assertStackIs([LeadingViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereAssertionsAboutSelfRetainingViewControllers(count: 1)
    }
    
    func test_marshroute_dismissesMiddleViewController_ifItsPresentingAndFollowingViewControllersWereDismissedWithoutMarshroute() {
        let recordingMarshrouteAssertionPlugin = RecordingMarshrouteAssertionPlugin()
        MarshrouteAssertionManager.setUpAssertionPlugin(recordingMarshrouteAssertionPlugin)
        recordingMarshrouteAssertionPlugin.assertWereNoRecordedAssertions()
        
        // =================================== STEP 1. SET LEADING VIEW CONTROLLER ==================================
        
        let (navigationController, _, leadingRouter) = MarshrouteFacade().navigationModule { _ in LeadingViewController() }
        navigationController.assertStackIs([LeadingViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereNoRecordedAssertions()
        
        // =================================== STEP 2. PUSH MIDDLE VIEW CONTROLLER 1 ==================================
        
        leadingRouter.pushWithoutAnimations(MiddleSelfRetainingViewController.self)
        navigationController.assertStackIs([LeadingViewController.self, MiddleSelfRetainingViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereNoRecordedAssertions()
        
        // =================================== STEP 3. PUSH MIDDLE VIEW CONTROLLER 2 ==================================
        
        let middleRouter = leadingRouter.pushWithoutAnimations(MiddleViewController.self)
        navigationController.assertStackIs([LeadingViewController.self, MiddleSelfRetainingViewController.self, MiddleViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereNoRecordedAssertions()
        
        // =================================== STEP 4. PUSH MIDDLE VIEW CONTROLLER 3 ==================================
        
        leadingRouter.pushWithoutAnimations(MiddleSelfRetainingViewController.self)
        navigationController.assertStackIs([LeadingViewController.self, MiddleSelfRetainingViewController.self, MiddleViewController.self, MiddleSelfRetainingViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereNoRecordedAssertions()
        
        // ================================== STEP 5. PUSH TRAILING VIEW CONTROLLER =================================
        
        leadingRouter.pushWithoutAnimations(TrailingViewController.self)
        navigationController.assertStackIs([LeadingViewController.self, MiddleSelfRetainingViewController.self, MiddleViewController.self, MiddleSelfRetainingViewController.self, TrailingViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereNoRecordedAssertions()
        
        // ============= STEP 6. REMOVE FIRST AND THIRD MIDDLE VIEW CONTROLLERS WITHOUT USING MARSHROUTE ============
        
        _ = navigationController.viewControllers.removeAll { $0 is MiddleSelfRetainingViewController }
        navigationController.assertStackIs([LeadingViewController.self, MiddleViewController.self, TrailingViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereNoRecordedAssertions()
        
        // ============================== STEP 7. DISMISS SECOND MIDDLE VIEW CONTROLLER =============================
        // ============================ VALIDATE WE RETURNED TO LEADING VIEW CONTROLLER ===========================
        
        middleRouter.dismissCurrentModule()
        navigationController.assertStackIs([LeadingViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereAssertionsAboutSelfRetainingViewControllers(count: 2)
    }
    
    func test_marshroute_setsNewRootViewController_ifMiddleViewControllersWereDismissedWithoutMarshroute() {
        let recordingMarshrouteAssertionPlugin = RecordingMarshrouteAssertionPlugin()
        MarshrouteAssertionManager.setUpAssertionPlugin(recordingMarshrouteAssertionPlugin)
        
        // =================================== STEP 1. SET LEADING VIEW CONTROLLER ==================================
        
        let (navigationController, _, leadingRouter) = MarshrouteFacade().navigationModule { _ in LeadingViewController() }
        navigationController.assertStackIs([LeadingViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereNoRecordedAssertions()
        
        // =================================== STEP 2. PUSH MIDDLE VIEW CONTROLLER 1 ==================================
        
        let middleRouter = leadingRouter.pushWithoutAnimations(MiddleSelfRetainingViewController.self)
        navigationController.assertStackIs([LeadingViewController.self, MiddleSelfRetainingViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereNoRecordedAssertions()
        
        // =================================== STEP 3. PUSH MIDDLE VIEW CONTROLLER 2 ==================================
        
        leadingRouter.pushWithoutAnimations(MiddleViewController.self)
        navigationController.assertStackIs([LeadingViewController.self, MiddleSelfRetainingViewController.self, MiddleViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereNoRecordedAssertions()
        
        // ================================== STEP 4. PUSH MIDDLE VIEW CONTROLLER 3 =================================
        
        leadingRouter.pushWithoutAnimations(MiddleSelfRetainingViewController.self)
        navigationController.assertStackIs([LeadingViewController.self, MiddleSelfRetainingViewController.self, MiddleViewController.self, MiddleSelfRetainingViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereNoRecordedAssertions()
        
        // ============= STEP 5. REMOVE SECOND AND THIRD MIDDLE VIEW CONTROLLERS WITHOUT USING MARSHROUTE ============
        _ = navigationController.viewControllers.removeAll { $0 is MiddleViewController }
        _ = navigationController.viewControllers.removeLast()
        navigationController.assertStackIs([LeadingViewController.self, MiddleSelfRetainingViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereNoRecordedAssertions()
        
        // ================================== STEP 6. SET NEW ROOT VIEW CONTROLLER =================================
        // =============================== VALIDATE WE HAVE NEW ROOT VIEW CONTROLLER ==============================
        middleRouter.setRootWithoutAnimations(TrailingViewController.self)
        navigationController.assertStackIs([TrailingViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereAssertionsAboutSelfRetainingViewControllers(count: 1)
    }

    func test_marshroute_focusesOnMiddleViewController_ifItsPresentingAndFollowingViewControllersWereDismissedWithoutMarshroute() {
        let recordingMarshrouteAssertionPlugin = RecordingMarshrouteAssertionPlugin()
        MarshrouteAssertionManager.setUpAssertionPlugin(recordingMarshrouteAssertionPlugin)
        
        // =================================== STEP 1. SET LEADING VIEW CONTROLLER ==================================
        
        let (navigationController, _, leadingRouter) = MarshrouteFacade().navigationModule { _ in LeadingViewController() }
        navigationController.assertStackIs([LeadingViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereNoRecordedAssertions()
        
        // ================================== STEP 2. PUSH MIDDLE VIEW CONTROLLER 1 =================================
        
        leadingRouter.pushWithoutAnimations(MiddleSelfRetainingViewController.self)
        navigationController.assertStackIs([LeadingViewController.self, MiddleSelfRetainingViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereNoRecordedAssertions()
        
        // ================================== STEP 3. PUSH MIDDLE VIEW CONTROLLER 2 =================================
        
        let middleRouter = leadingRouter.pushWithoutAnimations(MiddleViewController.self)
        navigationController.assertStackIs([LeadingViewController.self, MiddleSelfRetainingViewController.self, MiddleViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereNoRecordedAssertions()
        
        // =================================== STEP 4. PUSH MIDDLE VIEW CONTROLLER 3 =================================
        
        leadingRouter.pushWithoutAnimations(MiddleSelfRetainingViewController.self)
        navigationController.assertStackIs([LeadingViewController.self, MiddleSelfRetainingViewController.self, MiddleViewController.self, MiddleSelfRetainingViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereNoRecordedAssertions()
        
        // ================================== STEP 5. PUSH TRAILING VIEW CONTROLLER =================================
        
        leadingRouter.pushWithoutAnimations(TrailingViewController.self)
        navigationController.assertStackIs([LeadingViewController.self, MiddleSelfRetainingViewController.self, MiddleViewController.self, MiddleSelfRetainingViewController.self, TrailingViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereNoRecordedAssertions()
        
        // ============= STEP 6. REMOVE FIRST AND THIRD MIDDLE VIEW CONTROLLERS WITHOUT USING MARSHROUTE ============
        
        _ = navigationController.viewControllers.removeAll { $0 is MiddleSelfRetainingViewController }
        navigationController.assertStackIs([LeadingViewController.self, MiddleViewController.self, TrailingViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereNoRecordedAssertions()
        
        // ============================== STEP 7. FOCUS ON SECOND MIDDLE VIEW CONTROLLER ============================
        // ========================== VALIDATE WE RETURNED TO SECOND MIDDLE VIEW CONTROLLER =========================
        
        middleRouter.focusOnCurrentModule()
        navigationController.assertStackIs([LeadingViewController.self, MiddleViewController.self])
        recordingMarshrouteAssertionPlugin.assertWereAssertionsAboutSelfRetainingViewControllers(count: 2)
    }
}

private class LeadingViewController: UIViewController {}

private class MiddleViewController: UIViewController {}
    
private class MiddleSelfRetainingViewController: UIViewController {
    private var strongSelf: MiddleSelfRetainingViewController?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        strongSelf = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        strongSelf = self
    }
}

private class TrailingViewController: UIViewController {}

private final class RecordingMarshrouteAssertionPlugin: MarshrouteAssertionPlugin {
    private(set) var recordedAssertionMessages = [String]()
    
    func assert(
        _ condition: @autoclosure () -> Bool,
        _ message: @autoclosure () -> String,
        file: StaticString,
        line: UInt)
    {
        if !condition() {
            recordedAssertionMessages.append(message())
        }
    }
    
    func assertionFailure(
        _ message: @autoclosure () -> String,
        file: StaticString,
        line: UInt)
    {
        assert(false, message(), file: file, line: line)
    }
    
    func assertWereNoRecordedAssertions(file: StaticString = #file, line: UInt = #line) {
        if !recordedAssertionMessages.isEmpty {
            XCTFail("Found unexpected assertions:\n\(recordedAssertionMessages.joined(separator: "\n"))", file: file, line: line)
        }
    }
    
    func assertWereAssertionsAboutSelfRetainingViewControllers(count: Int, file: StaticString = #file, line: UInt = #line) {
        XCTAssert(recordedAssertionMessages.count == count, file: file, line: line)
        for i in 0..<count {
            guard let assertionMessage = recordedAssertionMessages.elementAtIndex(i) else { continue }
            XCTAssert(assertionMessage.contains("retain cycle"), file: file, line: line)
            XCTAssert(assertionMessage.contains("\(MiddleSelfRetainingViewController.self)"), file: file, line: line)
        }
    }
}

private extension Collection {
    func elementAtIndex(_ index: Index) -> Iterator.Element? {
        let intIndex = distance(from: startIndex, to: index)

        if intIndex >= 0 && intIndex < count {
            return self[index]
        } else {
            return nil
        }
    }
}

private extension UINavigationController {
    private var viewControllerTypes: [UIViewController.Type] {
        return viewControllers.map { type(of: $0) }
    }
    
    func assertStackIs(_ stack: [UIViewController.Type], file: StaticString = #file, line: UInt = #line) {
        let extectedStackDescriptions = stack.map { String(describing: $0) }
        let givenStackDescriptions = viewControllerTypes.map { String(describing: $0) }
        
        if extectedStackDescriptions != givenStackDescriptions {
            let errorMessage = """
                Stacks do not match:
                Expected: \(extectedStackDescriptions.joined(separator: ", "))
                Have: \(givenStackDescriptions.joined(separator: ", "))
                """
            XCTFail(errorMessage, file: file, line: line)
        }
    }
}

private extension BaseRouter {
    @discardableResult
    func pushWithoutAnimations(_ type: UIViewController.Type) -> BaseRouter {
        var _routerSeed: RouterSeed!
        
        pushViewControllerDerivedFrom({ routerSeed in
            _routerSeed = routerSeed
            return type.init(nibName: nil, bundle: nil)
        }, animator: NonAnimatedNavigationTransitionsAnimator())
        
        return BaseRouter(routerSeed: _routerSeed)
    }

    func setRootWithoutAnimations(_ type: UIViewController.Type) {
        setViewControllerDerivedFrom({_ in 
            type.init(nibName: nil, bundle: nil)
        }, animator: NonAnimatedResetNavigationTransitionsAnimator())
    }
}

private class NonAnimatedNavigationTransitionsAnimator: NavigationTransitionsAnimator {
    override var shouldAnimate: Bool {
        get { false }
        set {}
    }
}

private class NonAnimatedResetNavigationTransitionsAnimator: ResetNavigationTransitionsAnimator {
    override var shouldAnimate: Bool {
        get { false }
        set {}
    }
}
