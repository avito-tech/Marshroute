import UIKit

/// Методы, чтобы вернуться на экран текущего модуля
public protocol RouterFocusable: class {
    func focusOnCurrentModule(completion: (() -> ())?)
}

public extension RouterFocusable {
    func focusOnCurrentModule() {
        focusOnCurrentModule(completion: nil)
    }
}

// MARK: - RouterFocusable Default Impl
public extension RouterFocusable where Self: RouterTransitionable, Self: RouterIdentifiable, Self: RouterPresentable {
    func focusOnCurrentModule(completion: (() -> ())?)
    {
        let transitionsHandler = transitionsHandlerBox.unbox()
        
        if transitionsHandler === transitionsHandlerBox.unboxContainingTransitionsHandler() {
            if presentingTransitionsHandler == nil {
                debugPrint("`focusOnCurrentModule:` нельзя вызывать у корневого неанимирующего роутера приложения")
                return
            }
        }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion) // дожидаемся анимации возвращения на текущий модуль
        transitionsHandler.undoTransitionsAfter(transitionId: transitionId)
        CATransaction.commit()
    }
}
