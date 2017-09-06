protocol ViewLifecycleObservable {
    var onViewDidLoad: (() -> ())? { get set }
    var onViewWillAppear: (() -> ())? { get set }
    var onViewDidAppear: (() -> ())? { get set }
    var onViewWillDisappear: (() -> ())? { get set }
    var onViewDidDisappear: (() -> ())? { get set }
}
