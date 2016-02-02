import UIKit

class SplitViewTransitionsHandler {
    private unowned let splitViewController: UISplitViewController
    
    init(splitViewController: UISplitViewController) {
        self.splitViewController = splitViewController
    }
    
    var masterTransitionsHandler: NavigationTransitionsHandler? {
        didSet {
            masterTransitionsHandler?.navigationTransitionsHandlerDelegate = self
        }
    }
    
    var detailTransitionsHandler: NavigationTransitionsHandler? {
        didSet {
            detailTransitionsHandler?.navigationTransitionsHandlerDelegate = self
        }
    }
    
    var transitinsHandler: TransitionsHandler? {
        return firstResponderTransitionsHandler ?? masterTransitionsHandler
    }
    
    private var firstResponderTransitionsHandler: TransitionsHandler?
}

// MARK: - TransitionsHandler
extension SplitViewTransitionsHandler: TransitionsHandler {
    func performTransition(context context: ForwardTransitionContext) {
        transitinsHandler?.performTransition(context: context)
    }
    
    func undoTransitionsAfter(transitionId transitionId: TransitionId) {
        transitinsHandler?.undoTransitionsAfter(transitionId: transitionId)
    }
    
    func undoTransitionWith(transitionId transitionId: TransitionId) {
        transitinsHandler?.undoTransitionWith(transitionId: transitionId)
    }
    
    func undoAllChainedTransitions() {
        transitinsHandler?.undoAllChainedTransitions()
    }
    
    func undoAllTransitions() {
        transitinsHandler?.undoAllTransitions()
    }
    
    func resetWithTransition(context context: ForwardTransitionContext) {
        transitinsHandler?.resetWithTransition(context: context)
    }
}

// MARK: - NavigationTransitionsHandlerDelegate
extension SplitViewTransitionsHandler: NavigationTransitionsHandlerDelegate {
    func navigationTransitionsHandlerDidBecomeFirstResponder(handler: NavigationTransitionsHandler) {
        firstResponderTransitionsHandler = handler
    }
    
    func navigationTransitionsHandlerDidResignFirstResponder(handler: NavigationTransitionsHandler) {
        // эта реализация по умолчанию прокидывает сообщения в master.
        // можно написать вторую отдельную реализацию, если нужно
        firstResponderTransitionsHandler = masterTransitionsHandler
    }
}