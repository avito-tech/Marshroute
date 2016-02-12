/// Обертка для сильного хранения анимирующего обработчика переходов
struct AnimatingTransitionsHandlerWeakBox {
    weak var transitionsHandler: AnimatingTransitionsHandler?
}

// MARK: - convenience
extension AnimatingTransitionsHandlerWeakBox {
    init(strongBox: AnimatingTransitionsHandlerStrongBox) {
        self.transitionsHandler = strongBox.transitionsHandler
    }
}