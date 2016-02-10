//
//  Navigation_Prototype_Tests.swift
//  Navigation-Prototype-Tests
//
//  Created by Тимур Юсипов on 10/02/16.
//  Copyright © 2016 Тимур Юсипов. All rights reserved.
//

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

/// MARK: - TransitionContextsStackTests
class TransitionContextsStackTests: XCTestCase {
    var transitionContextsStackImpl: TransitionContextsStack?
    var autoZombieContext: CompletedTransitionContext?
    var neverZombieContext1: CompletedTransitionContext?
    var neverZombieContext2: CompletedTransitionContext?
    private let targetViewController = UIViewController()
    private let sourceViewController = UIViewController()
    private let dummyTransitionsHandler = DummyTransitionsHandler()
    
    override func setUp() {
        super.setUp()
        transitionContextsStackImpl = TransitionContextsStackImpl()
        
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
    
    func testExample() {
        guard let __stackImpl = transitionContextsStackImpl
            else { XCTAssert(false); return }
        guard let autoZombieContext = autoZombieContext
            else { XCTAssert(false); return }
        guard let neverZombieContext1 = neverZombieContext1
            else { XCTAssert(false); return }
        guard let neverZombieContext2 = neverZombieContext2
            else { XCTAssert(false); return }
        
        XCTAssertNil(__stackImpl.first)
        XCTAssertNil(__stackImpl.last)
        
        // append zombie. must still be empty
        __stackImpl.append(autoZombieContext)
        XCTAssertNil(__stackImpl.first, "при добавлении зомби, он удаляется при любом mutating'e или чтении стека")
        XCTAssertNil(__stackImpl.last, "при добавлении зомби, он удаляется при любом mutating'e или чтении стека")
        XCTAssertNil(__stackImpl[autoZombieContext.transitionId], "при добавлении зомби, он удаляется при любом mutating'e или чтении стека")
        XCTAssertNil(__stackImpl.preceding(transitionId:autoZombieContext.transitionId), "при добавлении зомби, он удаляется при любом mutating'e или чтении стека")
        XCTAssertNil(__stackImpl.popTo(transitionId: autoZombieContext.transitionId), "при добавлении зомби, он удаляется при любом mutating'e или чтении стека")
        
        // append not zombie. must become not empty
        __stackImpl.append(neverZombieContext1)
        XCTAssertNotNil(__stackImpl.first, "при добавлении не зомби, он не удаляется, пока жив targetViewController")
        XCTAssertNotNil(__stackImpl.last, "при добавлении не зомби, он не удаляется, пока жив targetViewController")
        XCTAssertEqual(__stackImpl.first!, __stackImpl.last!)
        XCTAssertEqual(__stackImpl.first!.transitionId, neverZombieContext1.transitionId, "вставили не зомби. достали его же")
        XCTAssertNotNil(__stackImpl[neverZombieContext1.transitionId], "при добавлении не зомби, он не удаляется, пока жив targetViewController")
        XCTAssertEqual(__stackImpl[neverZombieContext1.transitionId]!.transitionId, neverZombieContext1.transitionId, "вставили не зомби. достали его же")
        XCTAssertNil(__stackImpl.preceding(transitionId:neverZombieContext1.transitionId), "добавили одну запись. перед ней нет других записей")
        XCTAssertNil(__stackImpl.popTo(transitionId: neverZombieContext1.transitionId), "добавили одну запись. после нее нет других записей")
        XCTAssertNil(__stackImpl[neverZombieContext2.transitionId], "второго еще не добавляли")
        XCTAssertNil(__stackImpl.preceding(transitionId:neverZombieContext2.transitionId), "второго еще не добавляли")
        XCTAssertNil(__stackImpl.popTo(transitionId: neverZombieContext2.transitionId), "второго еще не добавляли")
        
        // pop via technique 1. must become empty again
        var last = __stackImpl.popLast()
        XCTAssertNotNil(last, "при добавлении не зомби, он не удаляется, пока жив targetViewController")
        XCTAssertEqual(last!.transitionId, neverZombieContext1.transitionId, "вставили не зомби. достали его же")
        XCTAssertNil(__stackImpl.first, "один append, один pop. должно быть пусто")
        XCTAssertNil(__stackImpl.last, "один append, один pop. должно быть пусто")
        XCTAssertNil(__stackImpl[neverZombieContext1.transitionId], "один append, один pop. должно быть пусто")
        XCTAssertNil(__stackImpl.preceding(transitionId:neverZombieContext1.transitionId), "один append, один pop. должно быть пусто")
        XCTAssertNil(__stackImpl.popTo(transitionId: neverZombieContext1.transitionId), "один append, один pop. должно быть пусто")
        XCTAssertNil(__stackImpl[neverZombieContext2.transitionId], "второго еще не добавляли")
        XCTAssertNil(__stackImpl.preceding(transitionId:neverZombieContext2.transitionId), "второго еще не добавляли")
        XCTAssertNil(__stackImpl.popTo(transitionId: neverZombieContext2.transitionId), "второго еще не добавляли")
        
        // append not zombie1 and not zombie 2. must become not empty again
        __stackImpl.append(neverZombieContext1)
        __stackImpl.append(neverZombieContext2)
        XCTAssertNotNil(__stackImpl.first, "при добавлении не зомби, он не удаляется, пока жив targetViewController")
        XCTAssertNotNil(__stackImpl.last, "при добавлении не зомби, он не удаляется, пока жив targetViewController")
        XCTAssertNotEqual(__stackImpl.first!, __stackImpl.last!)
        XCTAssertEqual(__stackImpl.first!.transitionId, neverZombieContext1.transitionId, "вставили первого не зомби первым. он должен быть первым")
        XCTAssertEqual(__stackImpl.last!.transitionId, neverZombieContext2.transitionId, "вставили второго не зомби вторым. он должен быть последним")
        XCTAssertNotNil(__stackImpl[neverZombieContext1.transitionId], "при добавлении не зомби, он не удаляется, пока жив targetViewController")
        XCTAssertEqual(__stackImpl[neverZombieContext1.transitionId]!.transitionId, neverZombieContext1.transitionId, "вставили не зомби. достали его же")
        XCTAssertNil(__stackImpl.preceding(transitionId:neverZombieContext1.transitionId), "перед первым не зомби никого нет")
        XCTAssertNotNil(__stackImpl[neverZombieContext2.transitionId], "при добавлении не зомби, он не удаляется, пока жив targetViewController")
        XCTAssertEqual(__stackImpl[neverZombieContext2.transitionId]!.transitionId, neverZombieContext2.transitionId, "вставили не зомби. достали его же")
        XCTAssertNotNil(__stackImpl.preceding(transitionId:neverZombieContext2.transitionId), "перед вторым не зомби идет первый")
        XCTAssertEqual(__stackImpl.preceding(transitionId:neverZombieContext2.transitionId)?.transitionId, neverZombieContext1.transitionId, "перед вторым не зомби идет первый")
        XCTAssertNil(__stackImpl.popTo(transitionId: neverZombieContext2.transitionId), "после второго не зомби никого нет")
        
        // pop via technique 2. must remain not empty
        let neverZombie2_popped = __stackImpl.popTo(transitionId: neverZombieContext1.transitionId)
        XCTAssertNotNil(neverZombie2_popped, "после первого не зомби должен был быть второй не зомби")
        XCTAssertEqual(neverZombie2_popped!.count, 1, "после первого не зомби должен был быть только второй не зомби")
        XCTAssertEqual(neverZombie2_popped!.last!.transitionId, neverZombieContext2.transitionId, "после первого не зомби должен был быть второй не зомби")
        XCTAssertNil(__stackImpl.popTo(transitionId: neverZombieContext1.transitionId), "после первого не зомби уже никого нет")
        XCTAssertNil(__stackImpl[neverZombieContext2.transitionId], "достали второго не зомби. больше его нет в стеке")
        XCTAssertNotNil(__stackImpl[neverZombieContext1.transitionId], "первый должен остаться в стеке")
        XCTAssertEqual(__stackImpl[neverZombieContext1.transitionId]!.transitionId, neverZombieContext1.transitionId, "первый должен остаться в стеке")
        XCTAssertNotNil(__stackImpl.first, "первый должен остаться в стеке")
        XCTAssertNotNil(__stackImpl.last, "первый должен остаться в стеке")
        XCTAssertEqual(__stackImpl.first!, __stackImpl.last!, "первый должен остаться в стеке")
        XCTAssertEqual(__stackImpl.first!.transitionId, neverZombieContext1.transitionId, "первый должен остаться в стеке")
        
        // pop via technique 1. must become empty again
        last = __stackImpl.popLast()
        XCTAssertNotNil(last, "при добавлении не зомби, он не удаляется, пока жив targetViewController")
        XCTAssertEqual(last!.transitionId, neverZombieContext1.transitionId, "вставили не зомби. достали его же")
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