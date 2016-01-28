import UIKit

class SplitViewTransitionsHandler {
    private let splitViewController: UISplitViewController
    
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
    
    private var firstResponderTransitionsHandler: TransitionsHandler?
}

// MARK: - TransitionsHandler
extension SplitViewTransitionsHandler: TransitionsHandler {
    func performTransition(context context: ForwardTransitionContext) {
        firstResponderTransitionsHandler?.performTransition(context: context)
    }
    
    func undoTransitionsAfter(transitionId transitionId: TransitionId) {
        firstResponderTransitionsHandler?.undoTransitionsAfter(transitionId: transitionId)
    }
    
    func undoTransitionWith(transitionId transitionId: TransitionId) {
        firstResponderTransitionsHandler?.undoTransitionWith(transitionId: transitionId)
    }
    
    func undoAllChainedTransitions() {
        firstResponderTransitionsHandler?.undoAllChainedTransitions()
    }
    
    func undoAllTransitions() {
        firstResponderTransitionsHandler?.undoAllTransitions()
    }
    
    func resetWithTransition(context context: ForwardTransitionContext) {
        firstResponderTransitionsHandler?.resetWithTransition(context: context)
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