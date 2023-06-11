enum ShelfResult {
    case cancelled
}

protocol ShelfModule: AnyObject {
    func dismissCurrentModule()
    var onFinish: ((ShelfModule, ShelfResult) -> ())? { get set }
}
