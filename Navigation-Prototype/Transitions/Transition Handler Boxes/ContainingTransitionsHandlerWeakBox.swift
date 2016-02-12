/// Обертка для сильного хранения содержащего обработчика переходов
struct ContainingTransitionsHandlerWeakBox {
    weak var transitionsHandler: ContainingTransitionsHandler?
}

// MARK: - convenience
extension ContainingTransitionsHandlerWeakBox {
    init(strongBox: ContainingTransitionsHandlerStrongBox) {
        self.transitionsHandler = strongBox.transitionsHandler
    }
}