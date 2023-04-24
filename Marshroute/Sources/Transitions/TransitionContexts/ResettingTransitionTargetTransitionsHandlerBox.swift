/// Варианты хранения обработчика переходов показываемого модуля в случае reset-перехода
public enum ResettingTransitionTargetTransitionsHandlerBox {
    case animating(AnimatingTransitionsHandler)

    public init(animatingTransitionsHandler: AnimatingTransitionsHandler)
    {
        self = .animating(animatingTransitionsHandler)
    }
}
