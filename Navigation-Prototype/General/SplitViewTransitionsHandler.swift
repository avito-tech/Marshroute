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
    func performTransition(contextCreationClosure closure: (generatedTransitionId: TransitionId) -> ForwardTransitionContext) {
        firstResponderTransitionsHandler?.performTransition(contextCreationClosure: closure)
    }
    
    func undoTransitions(tilContext context: BackwardTransitionContext) {
        firstResponderTransitionsHandler?.undoTransitions(tilContext: context)
    }
    
    func undoTransition(id transitionId: TransitionId) {
        firstResponderTransitionsHandler?.undoTransition(id: transitionId)
    }
    
    func undoAllChainedTransitions() {
        firstResponderTransitionsHandler?.undoAllChainedTransitions()
    }
    
    func undoAllTransitions() {
        firstResponderTransitionsHandler?.undoAllTransitions()
    }
    
    func undoAllChainedTransitionsAndResetWithTransition(
        contextCreationClosure closure: (generatedTransitionId: TransitionId) -> ForwardTransitionContext)
    {
        firstResponderTransitionsHandler?.undoAllChainedTransitionsAndResetWithTransition(contextCreationClosure: closure)
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