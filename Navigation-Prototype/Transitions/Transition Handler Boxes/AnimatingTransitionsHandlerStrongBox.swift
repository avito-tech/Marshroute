/// Обертка для сильного хранения анимирующего обработчика переходов
struct AnimatingTransitionsHandlerStrongBox {
    let transitionsHandler: AnimatingTransitionsHandler
}

// MARK: - convenience
extension AnimatingTransitionsHandlerStrongBox {    
    init?(weakBox: AnimatingTransitionsHandlerWeakBox) {
        guard let transitionsHandler = weakBox.transitionsHandler
            else { return nil }

        self.transitionsHandler = transitionsHandler
    }
}