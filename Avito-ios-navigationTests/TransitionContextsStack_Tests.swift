import XCTest


private func createCompletedTransitionContext(
    sourceViewController sourceViewController: UIViewController,
    sourceTransitionsHandler: TransitionsHandler,
    targetViewController: UIViewController,
    targetTransitionsHandlerBox: CompletedTransitionTargetTransitionsHandlerBox)
    -> CompletedTransitionContext?
{
    let animationLaunchingContext = NavigationAnimationLaunchingContext(
        transitionStyle: .Push,
        animationTargetParameters: NavigationAnimationTargetParameters(viewController: targetViewController),
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

/// MARK: - TransitionContextsStackTests
class TransitionContextsStackTests: XCTestCase {
    var __stackImpl: TransitionContextsStack?
    var autoZombieContext: CompletedTransitionContext?
    var neverZombieContext1: CompletedTransitionContext?
    var neverZombieContext2: CompletedTransitionContext?
    var oneDayZombieContext: CompletedTransitionContext?
    private let targetViewController = UIViewController()
    private var nillableTargetViewController: UIViewController?
    private let sourceViewController = UIViewController()
    private let dummyTransitionsHandler = DummyTransitionsHandler()
    
    override func setUp() {
        super.setUp()
        
        __stackImpl = TransitionContextsStackImpl()
        nillableTargetViewController = UIViewController()
        
        let autoZombieViewController = UIViewController()
        
        autoZombieContext = createCompletedTransitionContext(
            sourceViewController: autoZombieViewController,
            sourceTransitionsHandler: dummyTransitionsHandler,
            targetViewController: autoZombieViewController,
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
            targetViewController: nillableTargetViewController!,
            targetTransitionsHandlerBox: .init(animatingTransitionsHandler: dummyTransitionsHandler))
    }
    
    override func tearDown() {
        super.tearDown()
        
        __stackImpl = nil
        autoZombieContext = nil
        neverZombieContext1 = nil
        neverZombieContext2 = nil
        oneDayZombieContext = nil
        nillableTargetViewController = nil
    }
    
    func test_AddingZombie() {
        guard let __stackImpl = __stackImpl
            else { XCTFail(); return }
        guard let autoZombieContext = autoZombieContext
            else { XCTFail(); return }

        // append zombie. must still be empty
        __stackImpl.append(autoZombieContext)
        subtest_Stack(__stackImpl,
            toBeEmptyAfterAddingZombie:autoZombieContext
        )
    }
    
    func subtest_Stack(__stackImpl: TransitionContextsStack,
        toBeEmptyAfterAddingZombie zombieContext: CompletedTransitionContext)
    {
        XCTAssertNil(__stackImpl.first, "при добавлении зомби, он должен удаляться при любом mutating'e или чтении стека. стек должен быть пуст")
        XCTAssertNil(__stackImpl.last, "при добавлении зомби, он должен удаляться при любом mutating'e или чтении стека. стек должен быть пуст")
        XCTAssertNil(__stackImpl[zombieContext.transitionId], "при добавлении зомби, он должен удаляться при любом mutating'e или чтении стека. стек должен быть пуст")
        XCTAssertNil(__stackImpl.preceding(transitionId:zombieContext.transitionId), "при добавлении зомби, он должен удаляться при любом mutating'e или чтении стека. стек должен быть пуст")
        XCTAssertNil(__stackImpl.popTo(transitionId: zombieContext.transitionId), "при добавлении зомби, он должен удаляться при любом mutating'e или чтении стека. стек должен быть пуст")
    }
    
    func test_AddingNeverZombie() {
        guard let __stackImpl = __stackImpl
            else { XCTFail(); return }
        guard let neverZombieContext1 = neverZombieContext1
            else { XCTFail(); return }
        
        // append not zombie. must become not empty
        __stackImpl.append(neverZombieContext1)
        subtest_Stack(__stackImpl,
            toBeNotEmptyAfterAddingNeverZombie1: neverZombieContext1
        )
    }
    
    func subtest_Stack(__stackImpl: TransitionContextsStack,
        toBeNotEmptyAfterAddingNeverZombie1 neverZombieContext1: CompletedTransitionContext)
    {
        XCTAssertNotNil(__stackImpl.first, "при добавлении не зомби, он не должен удаляться из стека, пока жив targetViewController")
        XCTAssertNotNil(__stackImpl.last, "при добавлении не зомби, он не должен удаляться из стека, пока жив targetViewController")
        XCTAssertEqual(__stackImpl.first!, __stackImpl.last!)
        XCTAssertEqual(__stackImpl.first!.transitionId, neverZombieContext1.transitionId, "вставили не зомби. должны достать его же")
        XCTAssertNotNil(__stackImpl[neverZombieContext1.transitionId], "при добавлении не зомби, он не должен удаляться из стека, пока жив targetViewController")
        XCTAssertEqual(__stackImpl[neverZombieContext1.transitionId]!.transitionId, neverZombieContext1.transitionId, "вставили не зомби. должны достать его же")
        XCTAssertNil(__stackImpl.preceding(transitionId:neverZombieContext1.transitionId), "добавили одну запись. перед ней нет других записей")
        XCTAssertNil(__stackImpl.popTo(transitionId: neverZombieContext1.transitionId), "добавили одну запись. после нее нет других записей")
    }
    
    func test_AddingOneDayZombie_AndTurningItIntoZombie() {
        guard let __stackImpl = __stackImpl
            else { XCTFail(); return }
        guard let oneDayZombieContext = oneDayZombieContext
            else { XCTFail(); return }

        // append one day zombie. must become not empty
        __stackImpl.append(oneDayZombieContext)
        subtest_Stack(__stackImpl,
            toBeNotEmptyAfterAddingNeverZombie1: oneDayZombieContext
        )
        
        // turn one day zombie into zombie. must become empty
        nillableTargetViewController = nil
        
        subtest_Stack(__stackImpl,
            toBeEmptyAfterAddingZombie: oneDayZombieContext
        )
    }
    
    func test_AddingZombie_AddingNeverZombie() {
        guard let __stackImpl = __stackImpl
            else { XCTFail(); return }
        guard let autoZombieContext = autoZombieContext
            else { XCTFail(); return }
        guard let neverZombieContext1 = neverZombieContext1
            else { XCTFail(); return }
        
        // append zombie. must still be empty
        __stackImpl.append(autoZombieContext)
        subtest_Stack(__stackImpl,
            toBeEmptyAfterAddingZombie: autoZombieContext
        )

        // append not zombie. must become not empty
        __stackImpl.append(neverZombieContext1)
        subtest_Stack(__stackImpl,
            toBeNotEmptyAfterAddingNeverZombie1: neverZombieContext1
        )
    }
    
    func test_AddingZombie_AddingNeverZombie_PoppingNeverZombie() {
        guard let __stackImpl = __stackImpl
            else { XCTFail(); return }
        guard let autoZombieContext = autoZombieContext
            else { XCTFail(); return }
        guard let neverZombieContext1 = neverZombieContext1
            else { XCTFail(); return }
        
        // append zombie. must still be empty
        __stackImpl.append(autoZombieContext)
        subtest_Stack(__stackImpl,
            toBeEmptyAfterAddingZombie: autoZombieContext
        )
        
        // append not zombie 1. must become not empty
        __stackImpl.append(neverZombieContext1)
        subtest_Stack(__stackImpl,
            toBeNotEmptyAfterAddingNeverZombie1: neverZombieContext1
        )

        // pop via technique 1. must become empty again
        let neverZombie1_popped = __stackImpl.popLast()
        subtest_Stack(__stackImpl,
            toBeEmptyAfterAddingNeverZombie1: neverZombieContext1,
            andPoppingNeverZombie1: neverZombie1_popped
        )
    }
    
    func subtest_Stack(__stackImpl: TransitionContextsStack,
        toBeEmptyAfterAddingNeverZombie1 neverZombieContext1: CompletedTransitionContext,
        andPoppingNeverZombie1 neverZombie1_popped: RestoredTransitionContext?)
    {
        XCTAssertNotNil(neverZombie1_popped, "при добавлении не зомби, он не должен удаляться из стека, пока жив targetViewController")
        XCTAssertEqual(neverZombie1_popped!.transitionId, neverZombieContext1.transitionId, "вставили не зомби. должны достать его же")
        XCTAssertNil(__stackImpl.first, "один append, один pop. должно быть пусто")
        XCTAssertNil(__stackImpl.last, "один append, один pop. должно быть пусто")
        XCTAssertNil(__stackImpl[neverZombieContext1.transitionId], "один append, один pop. должно быть пусто")
        XCTAssertNil(__stackImpl.preceding(transitionId:neverZombieContext1.transitionId), "один append, один pop. должно быть пусто")
        XCTAssertNil(__stackImpl.popTo(transitionId: neverZombieContext1.transitionId), "один append, один pop. должно быть пусто")
    }
    
    func test_AddingZombie_AddingNeverZombie_AddingNeverZombie2() {
        guard let __stackImpl = __stackImpl
            else { XCTFail(); return }
        guard let autoZombieContext = autoZombieContext
            else { XCTFail(); return }
        guard let neverZombieContext1 = neverZombieContext1
            else { XCTFail(); return }
        guard let neverZombieContext2 = neverZombieContext2
            else { XCTFail(); return }
        
        // append not zombie. must still be empty
        __stackImpl.append(autoZombieContext)
        subtest_Stack(__stackImpl,
            toBeEmptyAfterAddingZombie: autoZombieContext
        )
        
        // append not zombie 1. must become not empty
        __stackImpl.append(neverZombieContext1)
        subtest_Stack(__stackImpl,
            toBeNotEmptyAfterAddingNeverZombie1: neverZombieContext1
        )
        
        // append not zombie 2. must remain not empty
        __stackImpl.append(neverZombieContext2)
        subtest_Stack(__stackImpl,
            toBeNotEmptyAfterAddingNeverZombie1: neverZombieContext1,
            andAddingNeverZombie2: neverZombieContext2
        )
    }
    
    func subtest_Stack(__stackImpl: TransitionContextsStack,
        toBeNotEmptyAfterAddingNeverZombie1 neverZombieContext1: CompletedTransitionContext,
        andAddingNeverZombie2 neverZombieContext2: CompletedTransitionContext)
    {
        XCTAssertNotNil(__stackImpl.first, "при добавлении не зомби, он не должен удаляться из стека, пока жив targetViewController")
        XCTAssertNotNil(__stackImpl.last, "при добавлении не зомби, он не должен удаляться из стека, пока жив targetViewController")
        XCTAssertNotEqual(__stackImpl.first!, __stackImpl.last!)
        XCTAssertEqual(__stackImpl.first!.transitionId, neverZombieContext1.transitionId, "вставили первого не зомби первым. он должен быть первым")
        XCTAssertEqual(__stackImpl.last!.transitionId, neverZombieContext2.transitionId, "вставили второго не зомби вторым. он должен быть последним")
        XCTAssertNotNil(__stackImpl[neverZombieContext1.transitionId], "при добавлении не зомби, он не должен удаляться из стека, пока жив targetViewController")
        XCTAssertEqual(__stackImpl[neverZombieContext1.transitionId]!.transitionId, neverZombieContext1.transitionId, "вставили не зомби. должны достать его же")
        XCTAssertNil(__stackImpl.preceding(transitionId:neverZombieContext1.transitionId), "перед первым не зомби никого не должно быть")
        XCTAssertNotNil(__stackImpl[neverZombieContext2.transitionId], "при добавлении не зомби, он не должен удаляться из стека, пока жив targetViewController")
        XCTAssertEqual(__stackImpl[neverZombieContext2.transitionId]!.transitionId, neverZombieContext2.transitionId, "вставили не зомби. должны достать его же")
        XCTAssertNotNil(__stackImpl.preceding(transitionId:neverZombieContext2.transitionId), "перед вторым не зомби должен идти первый")
        XCTAssertEqual(__stackImpl.preceding(transitionId:neverZombieContext2.transitionId)?.transitionId, neverZombieContext1.transitionId, "перед вторым не зомби должен идти первый")
        XCTAssertNil(__stackImpl.popTo(transitionId: neverZombieContext2.transitionId), "после второго не зомби никого не должно быть")
    }
    
    func test_AddingZombie_AddingNeverZombie_AddingNeverZombie2_PoppingNeverZombie2ViaTechnique1() {
        guard let __stackImpl = __stackImpl
            else { XCTFail(); return }
        guard let autoZombieContext = autoZombieContext
            else { XCTFail(); return }
        guard let neverZombieContext1 = neverZombieContext1
            else { XCTFail(); return }
        guard let neverZombieContext2 = neverZombieContext2
            else { XCTFail(); return }
        
        // append not zombie. must still be empty
        __stackImpl.append(autoZombieContext)
        subtest_Stack(__stackImpl,
            toBeEmptyAfterAddingZombie: autoZombieContext
        )
        
        // append not zombie 1. must become not empty
        __stackImpl.append(neverZombieContext1)
        subtest_Stack(__stackImpl,
            toBeNotEmptyAfterAddingNeverZombie1: neverZombieContext1
        )
        
        // append not zombie 2. must remain not empty
        __stackImpl.append(neverZombieContext2)
        subtest_Stack(__stackImpl, 
            toBeNotEmptyAfterAddingNeverZombie1: neverZombieContext1,
            andAddingNeverZombie2: neverZombieContext2
        )
        
        // pop via technique 1. must remain not empty
        let neverZombie2_popped = __stackImpl.popLast()
        subtest_Stack(__stackImpl,
            toBeNotEmptyAfterAddingNeverZombie1: neverZombieContext1,
            addingNeverZombie2: neverZombieContext2,
            andPoppingNeverZombie2ViaTechnique1: neverZombie2_popped
        )
    }
    
    func subtest_Stack(__stackImpl: TransitionContextsStack,
        toBeNotEmptyAfterAddingNeverZombie1 neverZombieContext1: CompletedTransitionContext,
        addingNeverZombie2 neverZombieContext2: CompletedTransitionContext,
        andPoppingNeverZombie2ViaTechnique1 neverZombie2_popped: RestoredTransitionContext?)
    {
        XCTAssertNotNil(neverZombie2_popped, "после первого не зомби должен был быть второй не зомби")
        XCTAssertEqual(neverZombie2_popped!.transitionId, neverZombieContext2.transitionId, "после первого не зомби должен был быть второй не зомби")
        XCTAssertNil(__stackImpl.popTo(transitionId: neverZombieContext1.transitionId), "после первого не зомби уже никого не должно быть")
        XCTAssertNil(__stackImpl[neverZombieContext2.transitionId], "достали второго не зомби. больше его не должно быть в стеке")
        XCTAssertNotNil(__stackImpl[neverZombieContext1.transitionId], "первый должен остаться в стеке")
        XCTAssertEqual(__stackImpl[neverZombieContext1.transitionId]!.transitionId, neverZombieContext1.transitionId, "первый должен остаться в стеке")
        XCTAssertNotNil(__stackImpl.first, "первый должен остаться в стеке")
        XCTAssertNotNil(__stackImpl.last, "первый должен остаться в стеке")
        XCTAssertEqual(__stackImpl.first!, __stackImpl.last!, "первый должен остаться в стеке")
        XCTAssertEqual(__stackImpl.first!.transitionId, neverZombieContext1.transitionId, "первый должен остаться в стеке")
    }
    
    func test_AddingZombie_AddingNeverZombie_AddingNeverZombie2_PoppingNeverZombie2ViaTechnique2() {
        guard let __stackImpl = __stackImpl
            else { XCTFail(); return }
        guard let autoZombieContext = autoZombieContext
            else { XCTFail(); return }
        guard let neverZombieContext1 = neverZombieContext1
            else { XCTFail(); return }
        guard let neverZombieContext2 = neverZombieContext2
            else { XCTFail(); return }
        
        // append not zombie. must still be empty
        __stackImpl.append(autoZombieContext)
        subtest_Stack(__stackImpl,
            toBeEmptyAfterAddingZombie: autoZombieContext
        )
        
        // append not zombie 1. must become not empty
        __stackImpl.append(neverZombieContext1)
        subtest_Stack(__stackImpl,
            toBeNotEmptyAfterAddingNeverZombie1: neverZombieContext1
        )
        
        // append not zombie 2. must remain not empty
        __stackImpl.append(neverZombieContext2)
        subtest_Stack(__stackImpl,
            toBeNotEmptyAfterAddingNeverZombie1: neverZombieContext1,
            andAddingNeverZombie2: neverZombieContext2
        )
        
        // pop via technique 2. must remain not empty
        let neverZombie2_poppedAsArray = __stackImpl.popTo(transitionId: neverZombieContext1.transitionId)
        subtest_Stack(__stackImpl,
            toBeNotEmptyAfterAddingNeverZombie1: neverZombieContext1,
            addingNeverZombie2: neverZombieContext2,
            andPoppingNeverZombie2ViaTechnique2: neverZombie2_poppedAsArray
        )
    }
    
    func subtest_Stack(__stackImpl: TransitionContextsStack,
        toBeNotEmptyAfterAddingNeverZombie1 neverZombieContext1: CompletedTransitionContext,
        addingNeverZombie2 neverZombieContext2: CompletedTransitionContext,
        andPoppingNeverZombie2ViaTechnique2 neverZombie2_poppedAsArray: [RestoredTransitionContext]?)
    {
    
        XCTAssertNotNil(neverZombie2_poppedAsArray, "после первого не зомби должен был быть второй не зомби")
        XCTAssertEqual(neverZombie2_poppedAsArray!.count, 1, "после первого не зомби должен был быть только второй не зомби")
        XCTAssertEqual(neverZombie2_poppedAsArray!.last!.transitionId, neverZombieContext2.transitionId, "после первого не зомби должен был быть второй не зомби")
        XCTAssertNil(__stackImpl.popTo(transitionId: neverZombieContext1.transitionId), "после первого не зомби уже никого не должно быть")
        XCTAssertNil(__stackImpl[neverZombieContext2.transitionId], "достали второго не зомби. больше его не должно быть в стеке")
        XCTAssertNotNil(__stackImpl[neverZombieContext1.transitionId], "первый должен остаться в стеке")
        XCTAssertEqual(__stackImpl[neverZombieContext1.transitionId]!.transitionId, neverZombieContext1.transitionId, "первый должен остаться в стеке")
        XCTAssertNotNil(__stackImpl.first, "первый должен остаться в стеке")
        XCTAssertNotNil(__stackImpl.last, "первый должен остаться в стеке")
        XCTAssertEqual(__stackImpl.first!, __stackImpl.last!, "первый должен остаться в стеке")
        XCTAssertEqual(__stackImpl.first!.transitionId, neverZombieContext1.transitionId, "первый должен остаться в стеке")
    }
    
    func test_AddingZombie_AddingNeverZombie_AddingNeverZombie2_PoppingNeverZombie2ViaTechnique1_PoppingNeverZombie1ViaTechnique1() {
        guard let __stackImpl = __stackImpl
            else { XCTFail(); return }
        guard let autoZombieContext = autoZombieContext
            else { XCTFail(); return }
        guard let neverZombieContext1 = neverZombieContext1
            else { XCTFail(); return }
        guard let neverZombieContext2 = neverZombieContext2
            else { XCTFail(); return }
        
        // append not zombie. must still be empty
        __stackImpl.append(autoZombieContext)
        subtest_Stack(__stackImpl,
            toBeEmptyAfterAddingZombie: autoZombieContext
        )
        
        // append not zombie 1. must become not empty
        __stackImpl.append(neverZombieContext1)
        subtest_Stack(__stackImpl,
            toBeNotEmptyAfterAddingNeverZombie1: neverZombieContext1
        )
        
        // append not zombie 2. must remain not empty
        __stackImpl.append(neverZombieContext2)
        subtest_Stack(__stackImpl,
            toBeNotEmptyAfterAddingNeverZombie1: neverZombieContext1,
            andAddingNeverZombie2: neverZombieContext2
        )
        
        // pop not zombie 2 via technique 1. must remain not empty
        let neverZombie2_popped = __stackImpl.popLast()
        subtest_Stack(__stackImpl,
            toBeNotEmptyAfterAddingNeverZombie1: neverZombieContext1,
            addingNeverZombie2: neverZombieContext2,
            andPoppingNeverZombie2ViaTechnique1: neverZombie2_popped
        )
        
        // pop not zombie 1 via technique 1. must become empty again
        let neverZombie1_popped = __stackImpl.popLast()
        subtest_Stack(__stackImpl,
            toBeEmptyAfterAddingNeverZombie1: neverZombieContext1,
            addingNeverZombie2: neverZombieContext2,
            poppingNeverZombie2AndPoppingNeverZombie1: neverZombie1_popped
        )
    }
    
    func test_AddingZombie_AddingNeverZombie_AddingNeverZombie2_PoppingNeverZombie2ViaTechnique2_PoppingNeverZombie1ViaTechnique1() {
        guard let __stackImpl = __stackImpl
            else { XCTFail(); return }
        guard let autoZombieContext = autoZombieContext
            else { XCTFail(); return }
        guard let neverZombieContext1 = neverZombieContext1
            else { XCTFail(); return }
        guard let neverZombieContext2 = neverZombieContext2
            else { XCTFail(); return }
        
        // append not zombie. must still be empty
        __stackImpl.append(autoZombieContext)
        subtest_Stack(__stackImpl,
            toBeEmptyAfterAddingZombie: autoZombieContext
        )
        
        // append not zombie 1. must become not empty
        __stackImpl.append(neverZombieContext1)
        subtest_Stack(__stackImpl,
            toBeNotEmptyAfterAddingNeverZombie1: neverZombieContext1
        )
        
        // append not zombie 2. must remain not empty
        __stackImpl.append(neverZombieContext2)
        subtest_Stack(__stackImpl,
            toBeNotEmptyAfterAddingNeverZombie1: neverZombieContext1,
            andAddingNeverZombie2: neverZombieContext2
        )
        
        // pop via technique 2. must remain not empty
        let neverZombie2_poppedAsArray = __stackImpl.popTo(transitionId: neverZombieContext1.transitionId)
        subtest_Stack(__stackImpl,
            toBeNotEmptyAfterAddingNeverZombie1: neverZombieContext1,
            addingNeverZombie2: neverZombieContext2,
            andPoppingNeverZombie2ViaTechnique2: neverZombie2_poppedAsArray
        )
        
        // pop not zombie 1 via technique 1. must become empty again
        let neverZombie1_popped = __stackImpl.popLast()
        subtest_Stack(__stackImpl,
            toBeEmptyAfterAddingNeverZombie1: neverZombieContext1,
            addingNeverZombie2: neverZombieContext2,
            poppingNeverZombie2AndPoppingNeverZombie1: neverZombie1_popped
        )
    }
    
    func subtest_Stack(__stackImpl: TransitionContextsStack,
        toBeEmptyAfterAddingNeverZombie1 neverZombieContext1: CompletedTransitionContext,
        addingNeverZombie2 neverZombieContext2: CompletedTransitionContext,
        poppingNeverZombie2AndPoppingNeverZombie1 neverZombie1_popped: RestoredTransitionContext?)
    {
        XCTAssertNotNil(neverZombie1_popped, "при добавлении не зомби, он не должен удаляться из стека, пока жив targetViewController")
        XCTAssertEqual(neverZombie1_popped!.transitionId, neverZombieContext1.transitionId, "вставили не зомби. должны достать его же")
        XCTAssertNil(__stackImpl.first, "два append'а, два pop'а. должно быть пусто")
        XCTAssertNil(__stackImpl.last, "два append'а, два pop'а. должно быть пусто")
        XCTAssertNil(__stackImpl[neverZombieContext1.transitionId], "два append'а, два pop'а. должно быть пусто")
        XCTAssertNil(__stackImpl[neverZombieContext2.transitionId], "два append'а, два pop'а. должно быть пусто")
        XCTAssertNil(__stackImpl.preceding(transitionId:neverZombieContext1.transitionId), "два append'а, два pop'а. должно быть пусто")
        XCTAssertNil(__stackImpl.preceding(transitionId:neverZombieContext2.transitionId), "два append'а, два pop'а. должно быть пусто")
        XCTAssertNil(__stackImpl.popTo(transitionId: neverZombieContext1.transitionId), "два append'а, два pop'а. должно быть пусто")
        XCTAssertNil(__stackImpl.popTo(transitionId: neverZombieContext2.transitionId), "два append'а, два pop'а. должно быть пусто")
    }
}