import XCTest

private class DummyTransitionsHandler: AnimatingTransitionsHandler {
    override func performTransition(context context: ForwardTransitionContext) {}
    override func undoTransitionsAfter(transitionId transitionId: TransitionId) {}
    override func undoTransitionWith(transitionId transitionId: TransitionId) {}
    override func undoAllChainedTransitions() {}
    override func undoAllTransitions() {}
    override func resetWithTransition(context context: ForwardTransitionContext) {}
    
    override func launchAnimationOfPerformingTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext) {}
    override func launchAnimationOfUndoingTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext) {}
    override func launchAnimationOfResettingWithTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext) {}
    
    init() {
        let coodinator = TransitionsCoordinatorImpl()
        super.init(transitionsCoordinator: coodinator)
    }
}


private func createCompletedTransitionContext(
    sourceViewController sourceViewController: UIViewController?,
    sourceTransitionsHandler: TransitionsHandler,
    targetViewController: UIViewController?,
    targetTransitionsHandlerBox: CompletedTransitionTargetTransitionsHandlerBox)
    -> CompletedTransitionContext
{
    let animationLaunchingContext = NavigationAnimationLaunchingContext(
        transitionStyle: .Push,
        animationTargetParameters: NavigationAnimationTargetParameters(),
        animator: NavigationTransitionsAnimator()
    )
    
    return CompletedTransitionContext(
        transitionId: TransitionIdGeneratorImpl().generateNewTransitionId(),
        sourceViewController: sourceViewController,
        sourceTransitionsHandler: sourceTransitionsHandler,
        targetViewController: targetViewController,
        targetTransitionsHandlerBox: targetTransitionsHandlerBox,
        storableParameters: nil,
        animationLaunchingContext: .Navigation(launchingContext: animationLaunchingContext)
    )
}

// MARK: - TransitionContextsStackTests
class TransitionContextsStackClientTests: XCTestCase {
    
    var __stackClientImpl: TransitionContextsStackClient?
    
    var autoZombieContext: CompletedTransitionContext?
    var neverZombieContext1: CompletedTransitionContext?
    var neverZombieContext2: CompletedTransitionContext?
    var oneDayZombieContext: CompletedTransitionContext?
    
    private let targetViewController = UIViewController()
    private var nillableTargetViewController: UIViewController?
    private let sourceViewController = UIViewController()
    private let dummyTransitionsHandler = DummyTransitionsHandler()
    private let dummyThirdPartyTransitionsHandler = DummyTransitionsHandler()
    
    override func setUp() {
        super.setUp()
        __stackClientImpl = TransitionContextsStackClientImpl()
        
        autoZombieContext = createCompletedTransitionContext(
            sourceViewController: nil,
            sourceTransitionsHandler: dummyTransitionsHandler,
            targetViewController: nil,
            targetTransitionsHandlerBox: .init(animatingTransitionsHandler: dummyTransitionsHandler))
        
        neverZombieContext1 = createCompletedTransitionContext(
            sourceViewController: sourceViewController,
            sourceTransitionsHandler: dummyTransitionsHandler,
            targetViewController: targetViewController,
            targetTransitionsHandlerBox: .init(animatingTransitionsHandler: dummyTransitionsHandler))
        
        neverZombieContext2 = createCompletedTransitionContext(
            sourceViewController: sourceViewController,
            sourceTransitionsHandler: dummyTransitionsHandler,
            targetViewController: targetViewController,
            targetTransitionsHandlerBox: .init(animatingTransitionsHandler: dummyTransitionsHandler))
        
        oneDayZombieContext = createCompletedTransitionContext(
            sourceViewController: sourceViewController,
            sourceTransitionsHandler: dummyTransitionsHandler,
            targetViewController: nillableTargetViewController,
            targetTransitionsHandlerBox: .init(animatingTransitionsHandler: dummyTransitionsHandler))
    }
    
    override func tearDown() {
        super.tearDown()
        
        __stackClientImpl = nil
        autoZombieContext = nil
        neverZombieContext1 = nil
        neverZombieContext2 = nil
        oneDayZombieContext = nil
        nillableTargetViewController = nil
    }
    
    func test_AppendingTransitionContextsWithGoodParameters() {
        guard let __stackClientImpl = __stackClientImpl
            else { XCTFail(); return }
        guard let neverZombieContext1 = neverZombieContext1
            else { XCTFail(); return }
        guard let neverZombieContext2 = neverZombieContext2
            else { XCTFail(); return }
        
        // adding transitions handler matching the context. must be added to the stack
        let appended = __stackClientImpl.appendTransition(context: neverZombieContext1, forTransitionsHandler: dummyTransitionsHandler)
        XCTAssertTrue(appended, "добавили переход, выполненный правильным обработчиком переходов. должен был добавиться")
        
        do { // lastTransitionForTransitionsHandler
            let lastTransition = __stackClientImpl.lastTransitionForTransitionsHandler(dummyTransitionsHandler)
            XCTAssertNotNil(lastTransition, "добавили переход, выполненный правильным обработчиком переходов. должен был добавиться")
            XCTAssertEqual(lastTransition!.transitionId, neverZombieContext1.transitionId, "добавили переход, выполненный правильным обработчиком переходов. должен был добавиться")
            
            XCTAssertNil(__stackClientImpl.lastTransitionForTransitionsHandler(dummyThirdPartyTransitionsHandler), "переход для этого обработчика не добавляли. его не должно быть в стеке")
        }
        
        do { // chainedTransitionForTransitionsHandler
            XCTAssertNil(__stackClientImpl.chainedTransitionForTransitionsHandler(dummyTransitionsHandler), "добавили один переход. дочерних переходов не было")
            XCTAssertNil(__stackClientImpl.chainedTransitionForTransitionsHandler(dummyThirdPartyTransitionsHandler), "переход для этого обработчика не добавляли. для него не должно быть дочерних переходов")
            
        }
        
        do { // chainedTransitionsHandlerBoxForTransitionsHandler
            XCTAssertNil(__stackClientImpl.chainedTransitionsHandlerBoxForTransitionsHandler(dummyTransitionsHandler), "добавили один переход. дочерних переходов не было")
            XCTAssertNil(__stackClientImpl.chainedTransitionsHandlerBoxForTransitionsHandler(dummyThirdPartyTransitionsHandler), "добавили один переход. дочерних переходов не было")
        }
        
        do { // transitionWith
            let transitionWithId = __stackClientImpl.transitionWith(transitionId: neverZombieContext1.transitionId, forTransitionsHandler: dummyTransitionsHandler)
            XCTAssertNotNil(transitionWithId, "добавили переход, выполненный правильным обработчиком переходов. должен был добавиться")
            XCTAssertEqual(transitionWithId!.transitionId, neverZombieContext1.transitionId, "добавили переход, выполненный правильным обработчиком переходов. должен был добавиться")
            
            let transitionWithNotAppenededId = __stackClientImpl.transitionWith(transitionId: neverZombieContext2.transitionId, forTransitionsHandler: dummyTransitionsHandler)
            XCTAssertNil(transitionWithNotAppenededId, "этот переход не добавляли. его не должно быть в стеке")
            
            let transitionWithNotAppendedTransitionsHandler = __stackClientImpl.transitionWith(transitionId: neverZombieContext1.transitionId, forTransitionsHandler: dummyThirdPartyTransitionsHandler)
            XCTAssertNil(transitionWithNotAppendedTransitionsHandler, "переход для этого обработчика не добавляли. его не должно быть в стеке")
        }
        
        do { // allTransitionsForTransitionsHandler
            let (chainedTransition, pushTransitions) = __stackClientImpl.allTransitionsForTransitionsHandler(dummyTransitionsHandler)
            XCTAssertNil(chainedTransition, "добавили один переход. дочерних переходов не было")
            XCTAssertNotNil(pushTransitions, "сделали один переход. должен был добавиться")
            XCTAssertEqual(pushTransitions!.count, 1, "сделали один переход. должен был добавиться")
            XCTAssertEqual(pushTransitions!.first?.transitionId, neverZombieContext1.transitionId, "сделали один переход. должен был добавиться")
            
            let allTransitionsForNotAppededTransitionsHandler = __stackClientImpl.allTransitionsForTransitionsHandler(dummyThirdPartyTransitionsHandler)
            XCTAssertNil(allTransitionsForNotAppededTransitionsHandler.chainedTransition, "переход для этого обработчика не добавляли. для него не должно быть дочерних переходов")
            XCTAssertNil(allTransitionsForNotAppededTransitionsHandler.pushTransitions, "переход для этого обработчика не добавляли. для него не должно быть push переходов")
        }
        
        do { // transitionsAfter
            let transitionsAfter = __stackClientImpl.transitionsAfter(transitionId: neverZombieContext1.transitionId, forTransitionsHandler: dummyTransitionsHandler, includingTransitionWithId: false)
            XCTAssertNil(transitionsAfter.chainedTransition , "добавили один переход. после него переходов не должно быть")
            XCTAssertNil(transitionsAfter.pushTransitions , "добавили один переход. после него переходов не должно быть")
            
            let transitionsAfterIncludingTransitionWithId = __stackClientImpl.transitionsAfter(transitionId: neverZombieContext1.transitionId, forTransitionsHandler: dummyTransitionsHandler, includingTransitionWithId: true)
            XCTAssertNil(transitionsAfterIncludingTransitionWithId.chainedTransition , "добавили один переход. после него переходов не должно быть")
            XCTAssertNotNil(transitionsAfterIncludingTransitionWithId.pushTransitions , "добавили один переход. должен был добавиться")
            XCTAssertEqual(transitionsAfterIncludingTransitionWithId.pushTransitions!.first?.transitionId, neverZombieContext1.transitionId, "сделали один переход. должен был добавиться")
            
            
            let transitionsAfterForNotAppededTransitionsHandler = __stackClientImpl.transitionsAfter(transitionId: neverZombieContext1.transitionId, forTransitionsHandler: dummyThirdPartyTransitionsHandler, includingTransitionWithId: false)
            XCTAssertNil(transitionsAfterForNotAppededTransitionsHandler.chainedTransition, "переход для этого обработчика не добавляли. для него не должно быть chained переходов")
            XCTAssertNil(transitionsAfterForNotAppededTransitionsHandler.pushTransitions, "переход для этого обработчика не добавляли. для него не должно быть chained переходов")
            
            let transitionsAfterIncludingTransitionWithIdForNotAppededTransitionsHandler = __stackClientImpl.transitionsAfter(transitionId: neverZombieContext1.transitionId, forTransitionsHandler: dummyThirdPartyTransitionsHandler, includingTransitionWithId: true)
            XCTAssertNil(transitionsAfterIncludingTransitionWithIdForNotAppededTransitionsHandler.chainedTransition, "переход для этого обработчика не добавляли. для него не должно быть chained переходов")
            XCTAssertNil(transitionsAfterIncludingTransitionWithIdForNotAppededTransitionsHandler.pushTransitions, "переход для этого обработчика не добавляли. для него не должно быть chained переходов")
        }
        
        do { // deleteTransitionsAfter
            XCTAssertFalse(__stackClientImpl.deleteTransitionsAfter(transitionId: neverZombieContext2.transitionId, forTransitionsHandler: dummyTransitionsHandler, includingTransitionWithId: false), "этот переход вообще не добавляли. он не должен удалиться")
            XCTAssertFalse(__stackClientImpl.deleteTransitionsAfter(transitionId: neverZombieContext2.transitionId, forTransitionsHandler: dummyTransitionsHandler, includingTransitionWithId: true), "этот переход вообще не добавляли. он не должен удалиться")
            XCTAssertFalse(__stackClientImpl.deleteTransitionsAfter(transitionId: neverZombieContext2.transitionId, forTransitionsHandler: dummyThirdPartyTransitionsHandler, includingTransitionWithId: false), "переход для этого обработчика не добавляли. он не должен удалиться")
            XCTAssertFalse(__stackClientImpl.deleteTransitionsAfter(transitionId: neverZombieContext2.transitionId, forTransitionsHandler: dummyThirdPartyTransitionsHandler, includingTransitionWithId: true), "переход для этого обработчика не добавляли. он не должен удалиться")

            XCTAssertFalse(__stackClientImpl.deleteTransitionsAfter(transitionId: neverZombieContext1.transitionId, forTransitionsHandler: dummyThirdPartyTransitionsHandler, includingTransitionWithId: false), "переход для этого обработчика не добавляли. он не должен удалиться")
            XCTAssertFalse(__stackClientImpl.deleteTransitionsAfter(transitionId: neverZombieContext1.transitionId, forTransitionsHandler: dummyThirdPartyTransitionsHandler, includingTransitionWithId: true), "переход для этого обработчика не добавляли. он не должен удалиться")
            XCTAssertFalse(__stackClientImpl.deleteTransitionsAfter(transitionId: neverZombieContext1.transitionId, forTransitionsHandler: dummyTransitionsHandler, includingTransitionWithId: false), "добавили один переход. после него переходов не должно быть")
            
            XCTAssertTrue(__stackClientImpl.deleteTransitionsAfter(transitionId: neverZombieContext1.transitionId, forTransitionsHandler: dummyTransitionsHandler, includingTransitionWithId: true), "добавили один переход. должен был добавиться. поэтому должен удалиться")
        }
    }
}