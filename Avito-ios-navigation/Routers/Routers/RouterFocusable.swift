import UIKit

/// Методы, чтобы вернуться на экран текущего модуля
public protocol RouterFocusable: class {
    func focusOnCurrentModule()
    func focusOnCurrentModule(completion completion: (() -> Void)?)
}

// MARK: - RouterFocusable Default Impl
public extension RouterFocusable where Self: RouterTransitionable, Self: RouterIdentifiable, Self: RouterPresentable {
    func focusOnCurrentModule(completion completion: (() -> Void)?) {
        guard let transitionsHandlerBox = transitionsHandlerBox
            else { return }
        
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
    
    func focusOnCurrentModule() {
        guard let transitionsHandlerBox = transitionsHandlerBox
            else { return }
        
        let transitionsHandler = transitionsHandlerBox.unbox()
        
        if transitionsHandler === transitionsHandlerBox.unboxContainingTransitionsHandler() {
            if presentingTransitionsHandler == nil {
                debugPrint("`focusOnCurrentModule:` нельзя вызывать у корневого неанимирующего роутера приложения")
                return
            }
        }
        
        transitionsHandler.undoTransitionsAfter(transitionId: transitionId)
    }
}