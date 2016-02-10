import XCTest

private class DummyTransitionsHandler: TransitionsHandler {
    func performTransition(context context: ForwardTransitionContext) {}
    func undoTransitionsAfter(transitionId transitionId: TransitionId) {}
    func undoTransitionWith(transitionId transitionId: TransitionId) {}
    func undoAllChainedTransitions() {}
    func undoAllTransitions() {}
    func resetWithTransition(context context: ForwardTransitionContext) {}
}

private func createCompletedTransitionContext(
    sourceViewController sourceViewController: UIViewController?,
    sourceTransitionsHandler: TransitionsHandler,
    targetViewController: UIViewController?,
    targetTransitionsHandler: TransitionsHandler)
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
        targetTransitionsHandler: targetTransitionsHandler,
        storableParameters: nil,
        animationLaunchingContext: .Navigation(launchingContext: animationLaunchingContext)
    )
}

class TransitionContextsStackSpy: TransitionContextsStack {
    private (set) var firstTimes = 0
    private (set) var lastTimes = 0
    private (set) var popLastTimes = 0
    
    private (set) var appendTimesPerParameter = [TransitionId : Int]()
    var appendTimesTotal: Int { return appendTimesPerParameter.map({ $1 }).reduce(0, combine: +) }
    
    private (set) var subscriptTimesPerParameter = [TransitionId : Int]()
    var subscriptTimes: Int { return subscriptTimesPerParameter.map({ $1 }).reduce(0, combine: +) }
    
    private (set) var popToTimesPerParameter = [TransitionId : Int]()
    var popToTimesTotal: Int { return popToTimesPerParameter.map({ $1 }).reduce(0, combine: +) }
    
    private (set) var precedingTimesPerParameter = [TransitionId : Int]()
    var precedingTimesTotal: Int {  return precedingTimesPerParameter.map({ $1 }).reduce(0, combine: +) }
    
    var first: RestoredTransitionContext? {
        firstTimes++; return nil
    }
    
    var last: RestoredTransitionContext? {
        lastTimes++; return nil
    }
    
    func popLast() -> RestoredTransitionContext? {
        popLastTimes++
        return nil
    }

    func append(context: CompletedTransitionContext) {
        let appendTimes = appendTimesPerParameter[context.transitionId] ?? 0
        appendTimesPerParameter[context.transitionId] = appendTimes + 1
    }
    
    subscript (transitionId: TransitionId) -> RestoredTransitionContext? {
        let subscriptTimes = subscriptTimesPerParameter[transitionId] ?? 0
        subscriptTimesPerParameter[transitionId] = subscriptTimes + 1
        return nil
    }
    
    func popTo(transitionId transitionId: TransitionId) -> [RestoredTransitionContext]? {
        let popToTimes = popToTimesPerParameter[transitionId] ?? 0
        popToTimesPerParameter[transitionId] = popToTimes + 1
        return nil
    }
    
    func preceding(transitionId transitionId: TransitionId) -> RestoredTransitionContext? {
        let precedingTimes = precedingTimesPerParameter[transitionId] ?? 0
        precedingTimesPerParameter[transitionId] = precedingTimes + 1
        return nil
    }
}


// MARK: - TransitionContextsStackTests
class TransitionContextsStackClientTests: XCTestCase {

    var __stackImplSpy: TransitionContextsStackSpy?
    var __stackClientImpl: TransitionContextsStackClient?

    var autoZombieContext: CompletedTransitionContext?
    var neverZombieContext1: CompletedTransitionContext?
    var neverZombieContext2: CompletedTransitionContext?

    private let targetViewController = UIViewController()
    private let sourceViewController = UIViewController()
    private let dummyTransitionsHandler = DummyTransitionsHandler()
    private let dummyThirdPartyTransitionsHandler = DummyTransitionsHandler()
    
    override func setUp() {
        super.setUp()
        __stackImplSpy = TransitionContextsStackSpy()
        __stackClientImpl = TransitionContextsStackClientImpl(transitionContextsStack: __stackImplSpy!)
        
        autoZombieContext = createCompletedTransitionContext(
            sourceViewController: nil,
            sourceTransitionsHandler: dummyTransitionsHandler,
            targetViewController: nil,
            targetTransitionsHandler: dummyTransitionsHandler)
        
        neverZombieContext1 = createCompletedTransitionContext(
            sourceViewController: sourceViewController,
            sourceTransitionsHandler: dummyTransitionsHandler,
            targetViewController: targetViewController,
            targetTransitionsHandler: dummyTransitionsHandler)
        
        neverZombieContext2 = createCompletedTransitionContext(
            sourceViewController: sourceViewController,
            sourceTransitionsHandler: dummyTransitionsHandler,
            targetViewController: targetViewController,
            targetTransitionsHandler: dummyTransitionsHandler)
    }

    func testCallingAppendOnStackSpy_AfterCallingAppendOnStackClient_WithGoodParameters() {
        guard let __stackImplSpy = __stackImplSpy
            else { XCTAssert(false); return }
        guard let __stackClientImpl = __stackClientImpl
            else { XCTAssert(false); return }
        guard let autoZombieContext = autoZombieContext
            else { XCTAssert(false); return }
        guard let neverZombieContext1 = neverZombieContext1
            else { XCTAssert(false); return }
        guard let neverZombieContext2 = neverZombieContext2
            else { XCTAssert(false); return }

        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[autoZombieContext.transitionId])
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[neverZombieContext1.transitionId])
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[neverZombieContext2.transitionId])
        XCTAssertEqual(__stackImplSpy.appendTimesTotal, 0)
        
        // passing good transitions handler: the one matching the context we want to append to the stack
        __stackClientImpl.appendTransition(context: autoZombieContext, forTransitionsHandler: dummyTransitionsHandler)
        __stackClientImpl.appendTransition(context: autoZombieContext, forTransitionsHandler: dummyTransitionsHandler)
        XCTAssertEqual(__stackImplSpy.appendTimesTotal, 2)
        XCTAssertEqual(__stackImplSpy.appendTimesPerParameter[autoZombieContext.transitionId], 2)
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[neverZombieContext1.transitionId])
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[neverZombieContext2.transitionId])

        // passing good transitions handler: the one matching the context we want to append to the stack
        __stackClientImpl.appendTransition(context: neverZombieContext1, forTransitionsHandler: dummyTransitionsHandler)
        XCTAssertEqual(__stackImplSpy.appendTimesTotal, 3)
        XCTAssertEqual(__stackImplSpy.appendTimesPerParameter[autoZombieContext.transitionId], 2)
        XCTAssertEqual(__stackImplSpy.appendTimesPerParameter[neverZombieContext1.transitionId], 1)
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[neverZombieContext2.transitionId])

        // passing good transitions handler: the one matching the context we want to append to the stack
        __stackClientImpl.appendTransition(context: neverZombieContext2, forTransitionsHandler: dummyTransitionsHandler)
        __stackClientImpl.appendTransition(context: neverZombieContext2, forTransitionsHandler: dummyTransitionsHandler)
        __stackClientImpl.appendTransition(context: neverZombieContext2, forTransitionsHandler: dummyTransitionsHandler)
        XCTAssertEqual(__stackImplSpy.appendTimesTotal, 6)
        XCTAssertEqual(__stackImplSpy.appendTimesPerParameter[autoZombieContext.transitionId], 2)
        XCTAssertEqual(__stackImplSpy.appendTimesPerParameter[neverZombieContext1.transitionId], 1)
        XCTAssertEqual(__stackImplSpy.appendTimesPerParameter[neverZombieContext2.transitionId], 3)
    }
    
    func testCallingAppendOnStackSpy_AfterCallingAppendOnStackClient_WithBadParameters() {
        guard let __stackImplSpy = __stackImplSpy
            else { XCTAssert(false); return }
        guard let __stackClientImpl = __stackClientImpl
            else { XCTAssert(false); return }
        guard let autoZombieContext = autoZombieContext
            else { XCTAssert(false); return }
        guard let neverZombieContext1 = neverZombieContext1
            else { XCTAssert(false); return }
        guard let neverZombieContext2 = neverZombieContext2
            else { XCTAssert(false); return }
        
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[autoZombieContext.transitionId])
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[neverZombieContext1.transitionId])
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[neverZombieContext2.transitionId])
        XCTAssertEqual(__stackImplSpy.appendTimesTotal, 0)
        
        // passing bad transitions handler: the one not matching the context we want to append to the stack
        __stackClientImpl.appendTransition(context: autoZombieContext, forTransitionsHandler: dummyThirdPartyTransitionsHandler)
        __stackClientImpl.appendTransition(context: autoZombieContext, forTransitionsHandler: dummyThirdPartyTransitionsHandler)
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[autoZombieContext.transitionId])
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[neverZombieContext1.transitionId])
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[neverZombieContext2.transitionId])
        XCTAssertEqual(__stackImplSpy.appendTimesTotal, 0)
        
        // passing bad transitions handler: the one not matching the context we want to append to the stack
        __stackClientImpl.appendTransition(context: neverZombieContext1, forTransitionsHandler: dummyThirdPartyTransitionsHandler)
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[autoZombieContext.transitionId])
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[neverZombieContext1.transitionId])
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[neverZombieContext2.transitionId])
        XCTAssertEqual(__stackImplSpy.appendTimesTotal, 0)
        
        // passing bad transitions handler: the one not matching the context we want to append to the stack
        __stackClientImpl.appendTransition(context: neverZombieContext2, forTransitionsHandler: dummyThirdPartyTransitionsHandler)
        __stackClientImpl.appendTransition(context: neverZombieContext2, forTransitionsHandler: dummyThirdPartyTransitionsHandler)
        __stackClientImpl.appendTransition(context: neverZombieContext2, forTransitionsHandler: dummyThirdPartyTransitionsHandler)
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[autoZombieContext.transitionId])
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[neverZombieContext1.transitionId])
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[neverZombieContext2.transitionId])
        XCTAssertEqual(__stackImplSpy.appendTimesTotal, 0)
    }
    
    func testCallingAppendOnStackSpy_AfterCallingAppendOnStackClient_WithGoodAndBadParameters() {
        guard let __stackImplSpy = __stackImplSpy
            else { XCTAssert(false); return }
        guard let __stackClientImpl = __stackClientImpl
            else { XCTAssert(false); return }
        guard let autoZombieContext = autoZombieContext
            else { XCTAssert(false); return }
        guard let neverZombieContext1 = neverZombieContext1
            else { XCTAssert(false); return }
        guard let neverZombieContext2 = neverZombieContext2
            else { XCTAssert(false); return }
        
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[autoZombieContext.transitionId])
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[neverZombieContext1.transitionId])
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[neverZombieContext2.transitionId])
        XCTAssertEqual(__stackImplSpy.appendTimesTotal, 0)
        
        // passing bad transitions handler: the one not matching the context we want to append to the stack
        __stackClientImpl.appendTransition(context: autoZombieContext, forTransitionsHandler: dummyThirdPartyTransitionsHandler)
        __stackClientImpl.appendTransition(context: autoZombieContext, forTransitionsHandler: dummyThirdPartyTransitionsHandler)
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[autoZombieContext.transitionId])
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[neverZombieContext1.transitionId])
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[neverZombieContext2.transitionId])
        XCTAssertEqual(__stackImplSpy.appendTimesTotal, 0)
        
        // passing good transitions handler: the one matching the context we want to append to the stack
        __stackClientImpl.appendTransition(context: autoZombieContext, forTransitionsHandler: dummyTransitionsHandler)
        __stackClientImpl.appendTransition(context: autoZombieContext, forTransitionsHandler: dummyTransitionsHandler)
        XCTAssertEqual(__stackImplSpy.appendTimesTotal, 2)
        XCTAssertEqual(__stackImplSpy.appendTimesPerParameter[autoZombieContext.transitionId], 2)
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[neverZombieContext1.transitionId])
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[neverZombieContext2.transitionId])
        
        // passing bad transitions handler: the one not matching the context we want to append to the stack
        __stackClientImpl.appendTransition(context: neverZombieContext1, forTransitionsHandler: dummyThirdPartyTransitionsHandler)
        XCTAssertEqual(__stackImplSpy.appendTimesTotal, 2)
        XCTAssertEqual(__stackImplSpy.appendTimesPerParameter[autoZombieContext.transitionId], 2)
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[neverZombieContext1.transitionId])
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[neverZombieContext2.transitionId])
        
        // passing good transitions handler: the one matching the context we want to append to the stack
        __stackClientImpl.appendTransition(context: neverZombieContext1, forTransitionsHandler: dummyTransitionsHandler)
        XCTAssertEqual(__stackImplSpy.appendTimesTotal, 3)
        XCTAssertEqual(__stackImplSpy.appendTimesPerParameter[autoZombieContext.transitionId], 2)
        XCTAssertEqual(__stackImplSpy.appendTimesPerParameter[neverZombieContext1.transitionId], 1)
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[neverZombieContext2.transitionId])
        
        // passing bad transitions handler: the one not matching the context we want to append to the stack
        __stackClientImpl.appendTransition(context: neverZombieContext2, forTransitionsHandler: dummyThirdPartyTransitionsHandler)
        __stackClientImpl.appendTransition(context: neverZombieContext2, forTransitionsHandler: dummyThirdPartyTransitionsHandler)
        __stackClientImpl.appendTransition(context: neverZombieContext2, forTransitionsHandler: dummyThirdPartyTransitionsHandler)
        XCTAssertEqual(__stackImplSpy.appendTimesTotal, 3)
        XCTAssertEqual(__stackImplSpy.appendTimesPerParameter[autoZombieContext.transitionId], 2)
        XCTAssertEqual(__stackImplSpy.appendTimesPerParameter[neverZombieContext1.transitionId], 1)
        XCTAssertNil(__stackImplSpy.appendTimesPerParameter[neverZombieContext2.transitionId])
        
        // passing good transitions handler: the one matching the context we want to append to the stack
        __stackClientImpl.appendTransition(context: neverZombieContext2, forTransitionsHandler: dummyTransitionsHandler)
        __stackClientImpl.appendTransition(context: neverZombieContext2, forTransitionsHandler: dummyTransitionsHandler)
        __stackClientImpl.appendTransition(context: neverZombieContext2, forTransitionsHandler: dummyTransitionsHandler)
        XCTAssertEqual(__stackImplSpy.appendTimesTotal, 6)
        XCTAssertEqual(__stackImplSpy.appendTimesPerParameter[autoZombieContext.transitionId], 2)
        XCTAssertEqual(__stackImplSpy.appendTimesPerParameter[neverZombieContext1.transitionId], 1)
        XCTAssertEqual(__stackImplSpy.appendTimesPerParameter[neverZombieContext2.transitionId], 3)
    }
}