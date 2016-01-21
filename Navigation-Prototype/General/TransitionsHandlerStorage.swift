/// для хранения сильной ссылки на обработчика переходов. (ссылку в общем случае должны хранить роутеры)
protocol TransitionsHandlerStorage: class {
    var transitionsHandler: TransitionsHandler? { get set }
}