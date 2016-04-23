import UIKit

/// Методы, чтобы вернуться на экран текущего модуля
public protocol RouterFocusable: class {
    func focusOnCurrentModule(completion completion: (() -> Void)?)
}

// MARK: - RouterFocusable Default Impl
extension RouterFocusable where Self: RouterTransitionable, Self: RouterIdentifiable, Self: RouterPresentable {
    public func focusOnCurrentModule(completion completion: (() -> Void)?) {
        guard let transitionsHandlerBox = transitionsHandlerBox
            else { return }
        
        let transitionsHandler = transitionsHandlerBox.unbox()
        
        if transitionsHandler === transitionsHandlerBox.unboxContainingTransitionsHandler() {
            assert(presentingTransitionsHandler != nil, "`focusOnCurrentModule:` нельзя вызывать у корневого роутера приложения")
        }
    
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion) // дожидаемся анимации возвращения на текущий модуль
        transitionsHandler.undoTransitionsAfter(transitionId: transitionId)
        CATransaction.commit()
    }
    
    public func focusOnCurrentModule() {
        focusOnCurrentModule(completion: nil)
    }
}