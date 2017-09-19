import UIKit

class BaseViewController: UIViewController, ViewLifecycleObservable, DisposeBag, DisposeBagHolder
{
    // MARK: - ViewLifecycleObservable
    var onViewDidLoad: (() -> ())?
    var onViewWillAppear: (() -> ())?
    var onViewDidAppear: (() -> ())?
    var onViewWillDisappear: (() -> ())?
    var onViewDidDisappear: (() -> ())?
    
    // MARK: - DisposeBagHolder
    let disposeBag: DisposeBag = DisposeBagImpl()
    
    // MARK: - Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
        
        automaticallyAdjustsScrollViewInsets = false
    }

    @available(*, unavailable, message: "use init")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("\(#function), \(self)")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onViewDidLoad?()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        onViewWillAppear?()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        onViewDidAppear?()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        onViewWillDisappear?()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        onViewDidDisappear?()
    }
}
