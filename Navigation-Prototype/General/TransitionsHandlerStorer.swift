/// для хранения сильной ссылки на обработчика переходов. (ссылку должны хранить роутеры)
protocol TransitionsHandlerStorer: class {
    var transitionsHandler: TransitionsHandler { get set }
}