import UIKit

/// Методы, чтобы вернуться на экран текущего модуля
public protocol RouterFocusable: class {
    func focusOnCurrentModule(completion completion: (() -> Void)?)
}

// MARK: - RouterFocusable Default Impl
extension RouterFocusable where Self: RouterTransitionable, Self: RouterIdentifiable {
    public func focusOnCurrentModule(completion completion: (() -> Void)?) {
        guard let transitionsHandlerBox = transitionsHandlerBox
            else { return }
        
        guard let animatingTransitionsHandler = transitionsHandlerBox.unboxAnimatingTransitionsHandler()
            else { assert(false, "`focusOnCurrentModule:` нельзя вызывать у роутеров с неанимирующих обработчиков переходов") }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion) // дожидаемся анимации возвращения на текущий модуль
        animatingTransitionsHandler.undoTransitionsAfter(transitionId: transitionId)
        CATransaction.commit()
    }
}