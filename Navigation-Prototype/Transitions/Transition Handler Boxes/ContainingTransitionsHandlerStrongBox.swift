/// Обертка для сильного хранения содержащего обработчика переходов
struct ContainingTransitionsHandlerStrongBox {
    let transitionsHandler: ContainingTransitionsHandler
}

// MARK: - convenience
extension ContainingTransitionsHandlerStrongBox {
    init?(weakBox: ContainingTransitionsHandlerWeakBox) {
        guard let transitionsHandler = weakBox.transitionsHandler
            else { return nil }
        
        self.transitionsHandler = transitionsHandler
    }
}